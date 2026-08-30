-- Two fixes stacked on nvim-lint so golangci-lint works after nvim's cwd
-- moves (e.g. <leader>gw into a worktree), not just from the dir nvim was
-- opened in.
--
-- Fix 1 -- dynamic filename_modifier on golangci-lint's args.
--   The bundled linter builds its `args` at plugin-load time by running
--   `go env GOMOD` at the current cwd and freezing a `filename_modifier`
--   (`:p` or `:h`) into a closure. Start nvim from a non-module parent
--   folder and that modifier stays `:p` forever, producing the wrong
--   argument shape after you :cd into a module. We surgically replace
--   just the function-arg inside the cached args with one that re-runs
--   the detection per invocation using an upward walk for go.mod.
--
-- Fix 2 -- cwd forced to the module root.
--   Even with correct args, golangci-lint's `typecheck` runs `go build`
--   under the hood, which needs the module context to resolve deps. The
--   try_lint override sets cwd to the enclosing go.mod's directory
--   (falls back to the buffer's dir for standalone files).
return {
  "mfussenegger/nvim-lint",
  -- Override LazyVim's `LazyFile` (= BufReadPre) so nvim-lint's ~90ms
  -- init cost runs AFTER the first buffer is rendered, not before it.
  -- BufReadPost fires once the buffer content is loaded; the user already
  -- sees the file by then, so the stall is imperceptible.
  event = { "BufReadPost", "BufNewFile" },
  -- Bump debounce from LazyVim's 100ms to 300ms so rapid InsertLeave
  -- events (e.g. switching windows) don't retrigger golangci-lint.
  opts = function(_, opts)
    opts.events = { "BufWritePost", "InsertLeave" }
    return opts
  end,
  -- Patch golangci-lint's frozen args + cwd override so linting works
  -- correctly after :cd into a worktree (see header comments for details).
  -- This fragment merges with the opts fragment above via lazy.nvim's
  -- standard opts-function chaining.
  config = function(_, opts)
    -- ── Replicate LazyVim's config (we must call it ourselves because we
    --    are replacing config, not just opts) ─────────────────────────────
    local lint = require("lint")
    for name, linter in pairs(opts.linters or {}) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        if type(linter.prepend_args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.prepend_args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    -- ── Walk up from the buffer's file looking for go.mod ────────────────
    -- Returns the directory containing go.mod, or nil outside a module.
    local function go_module_root(buf_path)
      if not buf_path or buf_path == "" then return nil end
      local dir = vim.fn.fnamemodify(buf_path, ":p:h")
      local found = vim.fs.find("go.mod", { upward = true, path = dir, type = "file" })[1]
      return found and vim.fn.fnamemodify(found, ":h") or nil
    end

    -- ── Fix 1: recompute golangci-lint's filename_modifier per invocation ─
    local golangci = lint.linters.golangcilint
    if golangci and type(golangci.args) == "table" then
      for i, arg in ipairs(golangci.args) do
        if type(arg) == "function" then
          golangci.args[i] = function()
            local buf_path = vim.api.nvim_buf_get_name(0)
            -- :h → package dir (in a module), :p → absolute path (standalone)
            local modifier = go_module_root(buf_path) and ":h" or ":p"
            return vim.fn.fnamemodify(buf_path, modifier)
          end
        end
      end
    end

    -- ── Fix 2: force cwd to module root for go files ──────────────────────
    local orig_try_lint = lint.try_lint
    lint.try_lint = function(names, try_opts)
      try_opts = try_opts or {}
      local bufnr = try_opts.bufnr or vim.api.nvim_get_current_buf()
      if try_opts.cwd == nil and vim.bo[bufnr].filetype == "go" then
        local buf_path = vim.api.nvim_buf_get_name(bufnr)
        try_opts.cwd = go_module_root(buf_path)
          or vim.fn.fnamemodify(buf_path, ":p:h")
      end
      return orig_try_lint(names, try_opts)
    end

    -- ── Debounced lint autocmd (300ms — higher than LazyVim's 100ms) ──────
    local M = {}
    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.lint()
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)
      names = vim.list_extend({}, names)
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end
      vim.list_extend(names, lint.linters_by_ft["*"] or {})
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(300, M.lint),
    })
  end,
}
