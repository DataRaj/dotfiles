-- WinEnter-driven auto-hide for the user-invoked `Snacks.terminal.toggle`
-- floats (lazysql, lazygit, etc.). When the user leaves the float group
-- entirely (moves into main buffer, neo-tree, etc.),
-- hide every Snacks-terminal float so the main splits aren't visually
-- overlaid. Non-Snacks floats (telescope, blink.cmp completion, LSP hover,
-- flash labels) are never touched; they're transient by design.
--
-- [DISABLED] auto-agents.nvim references removed (see lua/plugins/DISABLED_copilot/auto-agents.lua)

local M = {}

local function is_float(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return false
  end
  local cfg = vim.api.nvim_win_get_config(win)
  return cfg.relative ~= nil and cfg.relative ~= ""
end

local function find_win_for_buf(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return nil
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
  return nil
end

-- Hide every Snacks-terminal float currently visible in this tab page.
-- We scope on "is a Snacks terminal" rather than "is any float" to avoid
-- clobbering transient plugin floats (telescope pickers, completion menus,
-- signature help popups, etc.) that the user explicitly just opened.
function M.hide_all_tracked_floats()
  if not (Snacks and Snacks.terminal) then
    return
  end
  for _, term in ipairs(Snacks.terminal.list()) do
    if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      local win = find_win_for_buf(term.buf)
      if win and is_float(win) then
        if type(term.hide) == "function" then
          pcall(term.hide, term)
        else
          pcall(term.toggle, term)
        end
      end
    end
  end
end

-- Install the WinEnter autocmd. Re-entrant: nvim_create_augroup with
-- clear=true wipes any prior install, so re-sourcing is safe.
function M.install_auto_hide()
  local group = vim.api.nvim_create_augroup("FloatFocus_AutoHide", { clear = true })
  vim.api.nvim_create_autocmd("WinEnter", {
    group = group,
    callback = function()
      -- Still inside any floating window → we're in the "float group",
      -- don't disturb the others. This covers jumping between floats,
      -- lazysql / lazygit as well as transient plugin floats.
      if is_float(vim.api.nvim_get_current_win()) then
        return
      end
      -- Moved into a non-float (main buffer, neo-tree,
      -- any other split). Defer the hide so Snacks finishes whatever
      -- window operation triggered the WinEnter before we start closing
      -- things.
      vim.schedule(M.hide_all_tracked_floats)
    end,
  })
end

return M
