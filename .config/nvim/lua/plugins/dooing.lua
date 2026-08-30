return {
  "atiladefreitas/dooing",
  cmd = {
    "Dooing",
    "DooingLocal",
    "DooingDue",
  },
  keys = {
    { "<leader>td", "<cmd>Dooing<cr>", desc = "Toggle Global Todos (Dooing)" },
    { "<leader>tD", "<cmd>DooingLocal<cr>", desc = "Toggle Project/Local Todos (Dooing)" },
    { "<leader>tn", "<cmd>DooingDue<cr>", desc = "Show Due Todos (Dooing)" },
  },
  opts = {
    -- Enable v3.0.0+ Modern UI with status sections and folding
    ui = {
      style = "modern", -- "modern" layout with grouped headers
      sections = true, -- Group todos under IN PROGRESS, PENDING, DONE
      priority_bar = true, -- Minimal colored marker for priority
      tree_connectors = true, -- Visual connectors for nested subtasks/folds
    },
    timestamp = {
      enabled = true,
    },
    keymaps = {
      toggle_window = "<leader>td",
    },
  },
  config = function(_, opts)
    require("dooing").setup(opts)
  end,
}
