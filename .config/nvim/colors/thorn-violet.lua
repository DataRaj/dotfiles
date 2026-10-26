-- "thorn-violet" colorscheme: Royal Violet & Gilded Gold variant of Thorn.
-- Accessible directly via `:colorscheme thorn-violet` or `<leader>ut` Theme Picker.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.thorn_variant = "violet"
vim.g.colors_name = "thorn-violet"

local tp = require("config.theme.thorn_palette")
local palette = tp.palettes.violet

local hl = {}
tp.apply(hl, palette)

for group, spec in pairs(hl) do
  vim.api.nvim_set_hl(0, group, spec)
end
