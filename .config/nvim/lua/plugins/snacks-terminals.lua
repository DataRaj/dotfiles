-- Snacks terminal style override for rounded borders.
-- [DISABLED] auto-agents.nvim references removed (see lua/plugins/DISABLED_copilot/auto-agents.lua)

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.styles = opts.styles or {}
      opts.styles.terminal = vim.tbl_deep_extend("force", opts.styles.terminal or {}, {
        border = "rounded",
      })
    end,
  },
}
