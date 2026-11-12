-- ── codediff.nvim: VSCode-style live code review & side-by-side diff workspace ─
-- GitHub: https://github.com/esmuellert/codediff.nvim
-- Also used as diff viewer by atlas.nvim for GitHub PR reviews.

return {
  {
    "esmuellert/codediff.nvim",
    cmd = { "CodeDiff" },
    keys = {
      -- Original fast shortcuts:
      { "<leader>d1", "<cmd>CodeDiff<cr>", desc = "CodeDiff: Open Review Diff" },
      { "<leader>cd", "<cmd>CodeDiff<cr>", desc = "CodeDiff: Open Review Diff" },
      { "<leader>ch", "<cmd>CodeDiff history<cr>", desc = "CodeDiff: File History" },
      { "<leader>cm", "<cmd>CodeDiff merge<cr>", desc = "CodeDiff: 3-Way Merge" },
    },
    opts = {
      -- Custom options if needed
    },
    config = function(_, opts)
      require("codediff").setup(opts)
    end,
  },
}
