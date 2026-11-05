-- "thorn-light" colorscheme: Botanical Parchment, Sage Meadow & Deep Forest Ink.
-- Separate light theme counterpart to Dark Thorn.
-- Accessible via `:colorscheme thorn-light` or `<leader>ut` Theme Picker.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "light"
vim.g.thorn_variant = "light"

-- Load base plugin groups from thorn.nvim ("field" light mode) if available
pcall(function()
  require("lazy").load({ plugins = { "thorn" } })
  require("thorn").load({ theme = "field" })
end)

-- Apply our structured Thorn Light palette overrides
local tp = require("config.theme.thorn_palette")
local palette = tp.palettes.light

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

vim.g.colors_name = "thorn-light"
vim.g.terminal_color_0 = palette.term_black
vim.g.terminal_color_8 = palette.term_black_bright
