-- Make notifications stick around longer and map history view.
-- LazyVim routes `vim.notify` through snacks.nvim's notifier.
-- View history any time with `<leader>n` (LazyVim default) or `:lua Snacks.notifier.show_history()`.
-- Raw Neovim message log is always available via `:messages`.
-- Noice also keeps history via `:Noice` and `:Noice history`.

return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        timeout = 1500, -- fast dismiss (1.5s instead of 6s)
        style = "compact",
        width = { min = 20, max = 0.35 }, -- keep it small/compact
        height = { min = 1, max = 0.25 },
        top_down = false, -- position at bottom-right corner so it never blocks active editing
      },
    },
  },
}

