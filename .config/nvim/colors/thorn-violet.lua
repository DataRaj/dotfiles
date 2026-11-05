-- "thorn-violet" colorscheme: Royal Violet & Gilded Gold variant of Thorn.
-- Accessible directly via `:colorscheme thorn-violet` or `<leader>ut` Theme Picker.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.thorn_variant = "violet"

-- Load base plugin groups from thorn.nvim ("forest" dark mode) if available
pcall(function()
  require("lazy").load({ plugins = { "thorn" } })
  require("thorn").load({ theme = "forest" })
end)

local tp = require("config.theme.thorn_palette")
local palette = tp.palettes.violet

local hl = {}
tp.apply(hl, palette)

for group, spec in pairs(hl) do
  vim.api.nvim_set_hl(0, group, spec)
end

-- Remove any residual italics to match global no-italic style
for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
  local cur = vim.api.nvim_get_hl(0, { name = group, link = false })
  if cur.italic then
    cur.italic = false
    vim.api.nvim_set_hl(0, group, cur)
  end
end

vim.g.colors_name = "thorn-violet"
vim.g.terminal_color_0 = palette.term_black
vim.g.terminal_color_8 = palette.term_black_bright
