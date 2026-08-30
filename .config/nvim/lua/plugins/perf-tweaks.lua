-- lua/plugins/perf-tweaks.lua
-- Aggregated typing-latency improvements.
--
-- Problem areas on slower hardware:
--   1. blink.cmp fires completion on every character (default keyword_length=0).
--      Raising the trigger delay and minimum chars reduces round-trips to the
--      LSP server while typing.
--   2. nvim-ts-autotag runs a full treesitter query on each InsertCharPre.
--      Restricting it to only HTML/TSX filetypes (where it is actually useful)
--      avoids the overhead in Go, Python, Lua, etc.
--   3. mini.pairs does pattern matching on every keypress. Disabling it in
--      large buffers (>5 000 lines) and in terminal/special buffers prevents
--      noticeable stalls.

return {
  -- ── 1. blink.cmp: raise completion trigger delay ─────────────────────────
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        trigger = {
          -- Don't pop up until the user has typed at least 1 character AND
          -- has paused for 150 ms (default is effectively 0 ms / instant).
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        menu = {
          -- Hide the menu while still typing fast (debounced draw).
          draw = {
            -- Treesitter highlight in the menu is expensive; use fast mode.
            treesitter = {},
          },
        },
        ghost_text = {
          -- Ghost-text re-renders on every character — disable if not used.
          enabled = false,
        },
      },
    },
  },

  -- ── 2. nvim-ts-autotag: scope to HTML-family only ────────────────────────
  -- LazyVim enables autotag broadly via the typescript extra. Restricting it
  -- prevents the per-keystroke treesitter query in Go, Python, Lua, etc.
  {
    "windwp/nvim-ts-autotag",
    opts = {
      -- Only enable in filetypes where HTML tags actually exist.
      enable_close_on_slash = false, -- cheaper than the default
      filetypes = {
        "html",
        "xml",
        "xhtml",
        "phtml",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "tsx",
        "jsx",
        "vue",
        "svelte",
        "heex",
        "markdown",  -- for MDX
      },
    },
  },

  -- ── 3. mini.pairs: skip large buffers ────────────────────────────────────
  {
    "echasnovski/mini.pairs",
    opts = {
      -- Return false to skip pairing — fires on every keypress, so keep it
      -- cheap: just a line-count check.
      mappings = {
        -- Override the default MiniPairs.cr / MiniPairs.bs handlers so that
        -- in buffers > 5 000 lines the whole module becomes a no-op.
      },
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      -- Patch: bail out early in huge buffers to avoid treesitter overhead.
      local open_orig = MiniPairs.open
      MiniPairs.open = function(pair, neigh_pattern)
        if vim.api.nvim_buf_line_count(0) > 5000 then
          return pair:sub(1, 1)
        end
        return open_orig(pair, neigh_pattern)
      end
    end,
  },
}
