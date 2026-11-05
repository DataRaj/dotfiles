-- ── outline.nvim: GitHub / VS Code-style Left Symbol Outline Sidebar ─────────
-- Features:
--   - Docked on the LEFT side (width = 28), complementing Neo-tree on the right
--   - Lists functions, methods, structs, interfaces, fields, and constants
--   - Automatically groups `const (...)` / `var (...)` blocks and consecutive
--     constant/variable bunches into collapsible tree folders
--   - Click ("href" navigation) or press <CR> to jump directly to any symbol
--   - Auto-highlights the active symbol as you move through your code buffer

return {
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen", "OutlineClose", "OutlineFocus" },
    keys = {
      { "<leader>co", "<cmd>Outline<cr>", desc = "Toggle Code Outline (Left Sidebar)" },
      { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Symbols Outline (Left Sidebar)" },
    },
    opts = {
      outline_window = {
        position = "left",
        width = 28,
        relative_width = false,
        auto_width = {
          enabled = false,
        },
        wrap = false,
        focus_on_open = true,
        auto_close = false,
        auto_jump = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_cursorline = true,
        hide_cursor = false,
        center_on_jump = true,
        jump_highlight_duration = 400,
      },
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = false,
        highlight_hovered_item = true,
        auto_set_cursor = true,
        auto_update_events = {
          follow = { "CursorMoved" },
          items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "BufWritePost" },
        },
      },
      symbol_folding = {
        -- Fold deep children by default; keep top-level structs/functions visible
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
          only = false,
        },
        markers = { "", "" },
      },
      guides = {
        enabled = true,
        markers = {
          bottom = "└",
          middle = "├",
          vertical = "│",
          horizontal = "─",
        },
      },
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = false,
        width = 50,
        min_width = 40,
        relative_width = true,
        border = "rounded",
        winhl = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
      keymaps = {
        show_help = "g?",
        close = { "<Esc>", "q" },
        goto_location = "<CR>",
        peek_location = "o",
        goto_and_close = "<S-CR>",
        restore_location = "<C-g>",
        hover_symbol = "<C-Space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = { "h", "zc" },
        unfold = { "l", "zo" },
        fold_toggle = { "<Tab>", "za" },
        fold_toggle_all = "<S-Tab>",
        fold_all = { "W", "zM" },
        unfold_all = { "E", "zR" },
        fold_reset = "R",
        down_and_jump = "<C-j>",
        up_and_jump = "<C-k>",
      },
    },
    config = function(_, opts)
      local outline = require("outline")
      local parser = require("outline.parser")
      local lsp_utils = require("outline.utils.lsp")
      local symbols_mod = require("outline.symbols")
      local folding = require("outline.folding")

      -- ── Smart Grouping for `const (...)` / `var (...)` bunches ──────────────
      -- LSP servers (such as gopls) emit every constant in a `const ( ... )`
      -- block as a flat top-level Constant symbol. We wrap `parser.parse` so
      -- parenthesized `const (...)` / `var (...)` blocks and consecutive runs
      -- of top-level Constants/Variables are grouped into a collapsible parent
      -- node in the left Outline tree.
      if not parser._bunch_grouping_installed then
        parser._bunch_grouping_installed = true
        local orig_parse = parser.parse

        local function norm_kind(k)
          if type(k) == "number" then
            return k
          end
          return symbols_mod.str_to_kind[k] or 21
        end

        -- Find Go/TS/etc. multi-line `const (...)` or `var (...)` declaration blocks
        local function find_decl_blocks(bufnr)
          local blocks = {}
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            return blocks
          end
          local ok, ts_parser = pcall(vim.treesitter.get_parser, bufnr)
          if not ok or not ts_parser then
            return blocks
          end
          local trees = ts_parser:parse()
          if not trees or not trees[1] then
            return blocks
          end
          local root = trees[1]:root()
          for child in root:iter_children() do
            local ctype = child:type()
            if ctype == "const_declaration" or ctype == "var_declaration" then
              local sr, sc, er, ec = child:range()
              if er > sr then
                table.insert(blocks, {
                  kind = ctype == "const_declaration" and 14 or 13,
                  label = ctype == "const_declaration" and "const (...)" or "var (...)",
                  start_line = sr,
                  start_col = sc,
                  end_line = er,
                  end_col = ec,
                })
              end
            end
          end
          return blocks
        end

        local function make_group_node(label, kind, items, start_pos, end_pos)
          return {
            name = label,
            detail = string.format("(%d)", #items),
            kind = kind,
            range = {
              start = start_pos,
              ["end"] = end_pos,
            },
            selectionRange = {
              start = start_pos,
              ["end"] = start_pos,
            },
            children = items,
          }
        end

        local function group_top_level_symbols(raw_symbols, bufnr)
          if type(raw_symbols) ~= "table" or #raw_symbols == 0 then
            return raw_symbols
          end

          local sorted = lsp_utils.sort_symbols(vim.deepcopy(raw_symbols))
          local blocks = find_decl_blocks(bufnr)

          -- Pass 1: Group symbols falling inside AST `const (...)` / `var (...)` blocks
          local after_ast = {}
          local i = 1
          while i <= #sorted do
            local sym = sorted[i]
            local sym_range = lsp_utils.get_range(sym)
            local sline = sym_range and sym_range.start and sym_range.start.line or -1
            local matched_block = nil

            for _, blk in ipairs(blocks) do
              if sline >= blk.start_line and sline <= blk.end_line then
                matched_block = blk
                break
              end
            end

            if matched_block and ( not sym.children or #sym.children == 0 ) then
              local bucket = {}
              while i <= #sorted do
                local cur = sorted[i]
                local r = lsp_utils.get_range(cur)
                local l = r and r.start and r.start.line or -1
                if l >= matched_block.start_line and l <= matched_block.end_line and (not cur.children or #cur.children == 0) then
                  table.insert(bucket, cur)
                  i = i + 1
                else
                  break
                end
              end
              if #bucket >= 1 then
                table.insert(
                  after_ast,
                  make_group_node(
                    matched_block.label,
                    matched_block.kind,
                    bucket,
                    { line = matched_block.start_line, character = matched_block.start_col },
                    { line = matched_block.end_line, character = matched_block.end_col }
                  )
                )
              end
            else
              table.insert(after_ast, sym)
              i = i + 1
            end
          end

          -- Pass 2: Group any remaining consecutive runs (2+) of ungrouped top-level Constants or Variables
          local final = {}
          local j = 1
          while j <= #after_ast do
            local sym = after_ast[j]
            local k = norm_kind(sym.kind)
            local is_ungrouped_const_or_var = (k == 14 or k == 13) and (not sym.children or #sym.children == 0)

            if is_ungrouped_const_or_var then
              local run = { sym }
              local k_Next = j + 1
              while k_Next <= #after_ast do
                local nxt = after_ast[k_Next]
                local nk = norm_kind(nxt.kind)
                if nk == k and (not nxt.children or #nxt.children == 0) then
                  table.insert(run, nxt)
                  k_Next = k_Next + 1
                else
                  break
                end
              end

              if #run >= 2 then
                local first_r = lsp_utils.get_range(run[1])
                local last_r = lsp_utils.get_range(run[#run])
                local label = (k == 14) and "const (...)" or "var (...)"
                table.insert(
                  final,
                  make_group_node(label, k, run, first_r.start, last_r["end"])
                )
                j = k_Next
              else
                table.insert(final, sym)
                j = j + 1
              end
            else
              table.insert(final, sym)
              j = j + 1
            end
          end

          return final
        end

        parser.parse = function(response, bufnr)
          local ok, grouped = pcall(group_top_level_symbols, response, bufnr)
          if ok and grouped then
            return orig_parse(grouped, bufnr)
          end
          return orig_parse(response, bufnr)
        end
      end

      outline.setup(opts)

      -- ── Click ("Href") Navigation & Sidebar Width Guard ─────────────────────
      local FIXED_WIDTH = opts.outline_window.width or 28

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("OutlineClickAndGuard", { clear = true }),
        pattern = "Outline",
        callback = function(ev)
          -- Single left-click in Outline sidebar:
          --   - Clicking the fold chevron toggles fold
          --   - Clicking a symbol name jumps to that symbol in the code window ("href" behavior)
          vim.keymap.set("n", "<LeftRelease>", function()
            local sb = outline.sidebar
            if not sb or not sb.view or not sb.view:is_open() then
              return
            end
            local pos = vim.api.nvim_win_get_cursor(0)
            local line_idx = pos[1]
            local col_idx = pos[2]
            local node = sb.flats and sb.flats[line_idx]
            if not node then
              return
            end

            if folding.is_foldable(node) then
              -- If clicked on the chevron/guide area or if it's a synthetic const/var group, toggle fold
              local icon_end = node.prefix_length or 4
              if col_idx < icon_end or node.name == "const (...)" or node.name == "var (...)" then
                sb:_toggle_fold(false)
              end
            end

            -- Jump code window to the clicked symbol while keeping sidebar responsive
            sb:__goto_location(false)
          end, { buffer = ev.buf, silent = true, desc = "Outline: Click to jump / toggle fold" })

          -- Double-click jumps and focuses the code window
          vim.keymap.set("n", "<2-LeftMouse>", function()
            local sb = outline.sidebar
            if sb and sb.view and sb.view:is_open() then
              sb:_goto_location(true)
            end
          end, { buffer = ev.buf, silent = true, desc = "Outline: Double-click to jump & focus code" })
        end,
      })

      -- Lock Outline sidebar width on the left so closing splits never stretches it
      vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "BufDelete", "BufWipeout", "WinClosed" }, {
        group = vim.api.nvim_create_augroup("OutlineWidthGuard", { clear = true }),
        callback = function()
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                if ft == "Outline" then
                  local current_w = vim.api.nvim_win_get_width(win)
                  if current_w ~= FIXED_WIDTH then
                    pcall(vim.api.nvim_win_set_width, win, FIXED_WIDTH)
                  end
                end
              end
            end
          end)
        end,
      })
    end,
  },
}
