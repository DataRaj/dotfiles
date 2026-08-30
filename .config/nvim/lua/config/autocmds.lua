-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

require("utils.float_focus").install_auto_hide()

-- Persist the current colorscheme whenever it changes so that the next
-- nvim start can hot-reload it (see `plugins/theme.lua`). Fires for
-- picker selection, direct `:colorscheme` calls, and Snacks' cancel-path
-- revert — which is exactly what we want (the final state wins).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ThemeCachePersist", { clear = true }),
  callback = function(ev)
    require("utils.theme_cache").save(ev.match)
    local hl_groups = vim.fn.getcompletion("", "highlight")

    for _, group in ipairs(hl_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      -- If the highlight group explicitly uses italic, turn it off
      if hl.italic then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})

-- Initial `:colorscheme` applied during LazyVim setup renders with the wrong
-- background material under Ghostty's transparency/blur — it looks like bare
-- system vibrancy instead of the theme's bg. Re-applying the same colorscheme
-- after startup (what the picker does on selection) forces a full repaint that
-- renders correctly. So on VimEnter, artificially re-fire the cached theme.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ThemeRepaintOnEnter", { clear = true }),
  callback = function()
    local name = vim.g.colors_name
    if name and name ~= "" then
      pcall(vim.cmd.colorscheme, name)
    end
  end,
})

-- ── Inactive-window opacity (dim unfocused splits) ───────────────────────────
-- Sets `winblend` on windows when they lose focus so that only the active
-- window is fully opaque. Excluded: Neo-tree, floating windows, and terminal.
-- Adjust INACTIVE_BLEND (0=opaque, 30=noticeably dim) to taste.
local INACTIVE_BLEND = 15
local SKIP_FT = {
  ["neo-tree"] = true,
  ["TelescopePrompt"] = true,
  ["lazy"] = true,
  ["noice"] = true,
  ["notify"] = true,
}

local function set_blend(win, val)
  if not vim.api.nvim_win_is_valid(win) then return end
  -- Never touch floating windows
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative ~= "" then return end
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  if SKIP_FT[ft] then return end
  pcall(vim.api.nvim_set_option_value, "winblend", val, { win = win })
end

local blend_group = vim.api.nvim_create_augroup("InactiveWindowBlend", { clear = true })

vim.api.nvim_create_autocmd("WinLeave", {
  group = blend_group,
  callback = function()
    set_blend(vim.api.nvim_get_current_win(), INACTIVE_BLEND)
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = blend_group,
  callback = function()
    -- Un-dim the newly focused window
    set_blend(vim.api.nvim_get_current_win(), 0)
  end,
})

