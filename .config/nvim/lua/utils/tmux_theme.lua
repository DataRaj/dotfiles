-- ── Tmux + Neovim Theme Synchronizer & Dark/Light Quick Toggle ───────────────
-- Synchronizes Tmux statusline, window tabs, pills, and pane borders with
-- Neovim's active Thorn Dark (`thorn`) or Thorn Light (`thorn-light`) theme.

local M = {}

local PALETTES = {
  dark = {
    mode = "dark",
    status_style = "bg=#040f13,fg=#dff7ef",
    status_left = "#[fg=#040f13,bg=#88B497,bold]  #S #[fg=#88B497,bg=#040f13,nobold] ",
    status_right = "#[fg=#1B3030,bg=#040f13]#[fg=#88B497,bg=#1B3030]  #{b:pane_current_path} #[fg=#568270,bg=#1B3030]| #[fg=#9DCEE8,bg=#1B3030] %H:%M #[fg=#1B3030,bg=#040f13] #[fg=#F5A97A,bg=#040f13]#[fg=#040f13,bg=#F5A97A,bold]󰃭 %d-%b #[fg=#F5A97A,bg=#040f13]",
    win_format = "#[fg=#142122,bg=#040f13]#[fg=#568270,bg=#142122]#I #[fg=#568270,bg=#142122]| #[fg=#88B497,bg=#142122]#W#[fg=#142122,bg=#040f13]",
    win_current_format = "#[fg=#1B3030,bg=#040f13]#[fg=#F5A97A,bg=#1B3030,bold]#I #[fg=#568270,bg=#1B3030]| #[fg=#dff7ef,bg=#1B3030,bold]#W#[fg=#1B3030,bg=#040f13]",
    pane_border = "fg=#1B3030,bg=default",
    pane_active_border = "fg=#88B497,bg=default",
    message_style = "bg=#1B3030,fg=#dff7ef,bold",
    message_cmd_style = "bg=#1B3030,fg=#88B497",
    mode_style = "bg=#1B3030,fg=#dff7ef",
  },
  light = {
    mode = "light",
    status_style = "bg=#F4F6EE,fg=#1A2B23",
    status_left = "#[fg=#F4F6EE,bg=#216849,bold]  #S #[fg=#216849,bg=#F4F6EE,nobold] ",
    status_right = "#[fg=#E2EAD6,bg=#F4F6EE]#[fg=#216849,bg=#E2EAD6]  #{b:pane_current_path} #[fg=#667F6D,bg=#E2EAD6]| #[fg=#1B5C87,bg=#E2EAD6] %H:%M #[fg=#E2EAD6,bg=#F4F6EE] #[fg=#B84A27,bg=#F4F6EE]#[fg=#F4F6EE,bg=#B84A27,bold]󰃭 %d-%b #[fg=#B84A27,bg=#F4F6EE]",
    win_format = "#[fg=#E5ECDA,bg=#F4F6EE]#[fg=#667F6D,bg=#E5ECDA]#I #[fg=#667F6D,bg=#E5ECDA]| #[fg=#216849,bg=#E5ECDA]#W#[fg=#E5ECDA,bg=#F4F6EE]",
    win_current_format = "#[fg=#CBE0B4,bg=#F4F6EE]#[fg=#B84A27,bg=#CBE0B4,bold]#I #[fg=#667F6D,bg=#CBE0B4]| #[fg=#1A2B23,bg=#CBE0B4,bold]#W#[fg=#CBE0B4,bg=#F4F6EE]",
    pane_border = "fg=#D4DEC6,bg=default",
    pane_active_border = "fg=#216849,bg=default",
    message_style = "bg=#E2EAD6,fg=#1A2B23,bold",
    message_cmd_style = "bg=#E2EAD6,fg=#216849",
    mode_style = "bg=#CBE0B4,fg=#1A2B23",
  },
}

--- Determine whether a given colorscheme name is light mode
---@param name? string
---@return boolean
function M.is_light(name)
  local cs = name or vim.g.colors_name or ""
  if cs == "thorn-light" or cs == "thorn-field" then
    return true
  end
  if cs == "thorn" or cs == "thorn-forest" or cs == "thorn-violet" then
    return false
  end
  return vim.o.background == "light"
end

--- Push the matching statusline & border palette to the running Tmux server
---@param theme_name? string
function M.sync_tmux(theme_name)
  if vim.fn.executable("tmux") ~= 1 then
    return
  end

  local p = M.is_light(theme_name) and PALETTES.light or PALETTES.dark

  local cmd = {
    "tmux",
    "set", "-g", "@thorn_mode", p.mode, ";",
    "set", "-g", "status-style", p.status_style, ";",
    "set", "-g", "status-left", p.status_left, ";",
    "set", "-g", "status-right", p.status_right, ";",
    "setw", "-g", "window-status-format", p.win_format, ";",
    "setw", "-g", "window-status-current-format", p.win_current_format, ";",
    "set", "-g", "pane-border-style", p.pane_border, ";",
    "set", "-g", "pane-active-border-style", p.pane_active_border, ";",
    "set", "-g", "message-style", p.message_style, ";",
    "set", "-g", "message-command-style", p.message_cmd_style, ";",
    "setw", "-g", "mode-style", p.mode_style,
  }

  if vim.system then
    vim.system(cmd, { detach = true }, function() end)
  else
    vim.fn.jobstart(cmd, { detach = true })
  end
end

--- Quickly toggle both Neovim and Tmux between Thorn Dark (`thorn`) and Thorn Light (`thorn-light`)
function M.toggle()
  local currently_light = M.is_light(vim.g.colors_name)
  if currently_light then
    vim.cmd("noautocmd set background=dark")
    vim.cmd.colorscheme("thorn")
    require("utils.theme_cache").save("thorn")
    M.sync_tmux("thorn")
    vim.notify("Switched to Thorn Dark (Neovim + Tmux)", vim.log.levels.INFO, { title = "Theme Toggle" })
  else
    vim.cmd.colorscheme("thorn-light")
    require("utils.theme_cache").save("thorn-light")
    M.sync_tmux("thorn-light")
    vim.notify("Switched to Thorn Light (Neovim + Tmux)", vim.log.levels.INFO, { title = "Theme Toggle" })
  end
end

return M
