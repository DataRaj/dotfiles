-- ── diffbandit.nvim: Side-by-side diffs with connector gutter & editable target ─
return {
  {
    "CoreyKaylor/diffbandit.nvim",
    cmd = {
      "DiffBandit",
      "DiffBanditBuffers",
      "DiffBanditFolderDiff",
      "DiffBanditGit",
      "DiffBanditGitCurrent",
      "DiffBanditCommitPanel",
      "DiffBanditGitMenu",
      "DiffBanditGitLog",
      "DiffBanditGitCommit",
      "DiffBanditGitCompare",
      "DiffBanditGitCheckout",
      "DiffBanditMerge",
      "DiffBanditClose",
      "DiffBanditLaunch",
    },
    keys = {
      { "<leader>d1", "<cmd>DiffBanditGit<cr>", desc = "DiffBandit: Open Git Diff" },
      { "<leader>d2", "<cmd>DiffBanditClose<cr>", desc = "DiffBandit: Close Diff" },
      { "<leader>d3", "<cmd>DiffBanditGitCurrent<cr>", desc = "DiffBandit: Diff Current File" },
      { "<leader>dc", "<cmd>DiffBanditCommitPanel<cr>", desc = "DiffBandit: Commit Panel" },
      { "<leader>dm", "<cmd>DiffBanditGitMenu<cr>", desc = "DiffBandit: Git Workflow Menu" },
    },
    config = function()
      require("diffbandit").setup()
    end,
  },
}
