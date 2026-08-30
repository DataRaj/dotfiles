return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- Place neo-tree on the right side permanently
      position = "right",
      window = {
        -- Hard-lock sidebar to 25 columns on the right.
        -- Do NOT use a function here — function-width is re-evaluated on
        -- every WinResized event and is the primary cause of the sidebar
        -- blowing out to full width when splits are opened/closed.
        position = "right",
        width = 25,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        check_gitignore_in_search = false,
        components = {
          name = function(config, node, state)
            local cc = require("neo-tree.sources.common.components")
            local result = cc.name(config, node, state)
            local name = node.name or ""
            if node.type ~= "directory" and name:sub(1, 1) == "." then
              result.highlight = "NeoTreeDotfile"
            end
            return result
          end,
        },
      },
    },
  },

  -- ── Sidebar width + position guard ───────────────────────────────────────
  -- After any window-close / window-resize event, walk all windows on the
  -- current tabpage and force every neo-tree sidebar window back to exactly
  -- 25 columns. This stops the sidebar from expanding to full width when the
  -- only split closes, or when VimResized fires during terminal resize.
  -- Triggers on BufDelete / BufWipeout / WinClosed too so that pressing "q"
  -- to close a buffer is also caught.
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      local FIXED_WIDTH = 25

      local function lock_neotree_width()
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
              if ft == "neo-tree" then
                local current_w = vim.api.nvim_win_get_width(win)
                if current_w ~= FIXED_WIDTH then
                  pcall(vim.api.nvim_win_set_width, win, FIXED_WIDTH)
                end
              end
            end
          end
        end)
      end

      vim.api.nvim_create_autocmd(
        { "WinResized", "VimResized", "BufDelete", "BufWipeout", "WinClosed" },
        {
          group = vim.api.nvim_create_augroup("NeoTreeWidthGuard", { clear = true }),
          callback = lock_neotree_width,
        }
      )
    end,
  },
}
