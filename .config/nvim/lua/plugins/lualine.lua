-- Prepend the repo+worktree-marker component (provided by worktree.nvim) to
-- lualine's section_b so the statusline shows `repo │ branch`, with a
-- trailing `(wt)` when the cwd is a linked git worktree.

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Worktree component on the left
      table.insert(opts.sections.lualine_b, 1, {
        require("worktree").lualine_component,
      })

      -- [DISABLED] Copilot status pill removed
      -- To re-enable Copilot status:
      -- 1. Move lua/plugins/DISABLED_copilot/copilot.lua to lua/plugins/
      -- 2. Uncomment the copilot_status section below

      -- opts.sections = opts.sections or {}
      -- opts.sections.lualine_x = opts.sections.lualine_x or {}
      --
      -- local copilot_status = {
      --   function()
      --     local ok, copilot_api = pcall(require, "copilot.api")
      --     if not ok then return "" end
      --     local status = copilot_api.status and copilot_api.status.data
      --     if status and status.status == "InProgress" then
      --       return " Copilot…"
      --     elseif status and status.status == "Warning" then
      --       return "⚠ Copilot"
      --     elseif vim.b.copilot_enabled == false then
      --       return "✗ Copilot"
      --     else
      --       return " Copilot"
      --     end
      --   end,
      --   color = function()
      --     local ok, copilot_api = pcall(require, "copilot.api")
      --     if not ok then return { fg = "#6c7086" } end
      --     local status = copilot_api.status and copilot_api.status.data
      --     if vim.b.copilot_enabled == false then
      --       return { fg = "#f38ba8" }
      --     elseif status and status.status == "Warning" then
      --       return { fg = "#f9e2af" }
      --     else
      --       return { fg = "#a6e3a1" }
      --     end
      --   end,
      --   cond = function()
      --     return package.loaded["copilot"] ~= nil
      --   end,
      -- }
      --
      -- table.insert(opts.sections.lualine_x, 1, copilot_status)

      return opts
    end,
  },
}
