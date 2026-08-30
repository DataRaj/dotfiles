-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ── Treesitter parser priority fix ─────────────────────────────────────────
-- nvim ships a stale vim.so at site/parser/ that lacks the "tab" node type
-- expected by the current nvim-treesitter highlight queries (e.g. vim/highlights.scm:113).
-- Prepending the nvim-treesitter parser path here (before lazy.nvim appends it
-- later) ensures the newer parser wins the rtp lookup. Must happen in options.lua
-- so it's in effect before any FileType/BufReadPost autocmds fire.
local ts_parser_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"
if vim.fn.isdirectory(ts_parser_path) == 1 then
  vim.opt.rtp:prepend(ts_parser_path)
end

vim.opt.relativenumber = true
vim.opt.autoread = true

-- ── Typing-latency fixes ────────────────────────────────────────────────────
-- Lower CursorHold / CursorHoldI interval (default 4000ms → 250ms).
-- Drives faster gitsigns column updates and diagnostic float pop-ups without
-- triggering the heavy BufWritePre chain.
vim.opt.updatetime = 250
-- Shorter leader timeout so <leader>X sequences resolve quickly.
vim.opt.timeoutlen = 300
-- No swap-file I/O during editing (periodic fsync is a hidden stall source).
vim.opt.swapfile = false

-- Use 4 spaces for indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.statuscolumn = "%=%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} %s"

-- Limit which fenced-code-block languages Treesitter parses inline in .md
-- files. Without this every fence triggers a separate grammar injection
-- (bash, sql, yaml, ... everything), which is the primary driver of the
-- ~75ms FileType cost on first markdown open.
vim.g.markdown_fenced_languages = { "go", "python", "typescript", "bash", "lua", "json", "yaml" }
