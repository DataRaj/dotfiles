return {
  "esmuellert/codediff.nvim",
  cmd = { "Codediff", "CodediffToggle", "CodediffClose" },
  keys = {
    { "<leader>d1", "<cmd>Codediff<cr>", desc = "Open Codediff" },
    { "<leader>d2", "<cmd>CodediffClose<cr>", desc = "Close Codediff" },
    { "<leader>d3", "<cmd>CodediffToggle<cr>", desc = "Toggle Codediff" },
  },
  config = function()
    require("codediff").setup({
      -- Add your custom options here if needed
    })
  end,
}
