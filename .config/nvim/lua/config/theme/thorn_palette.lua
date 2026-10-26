local M = {}

-- ============================================================================
-- THORN PALETTES
-- ============================================================================

M.palettes = {
  -- Original Dark Emerald / Teal Palette
  emerald = {
    name = "thorn",
    bg = "#040f13",
    bg_nc = "#030c0f",
    bg_float = "#1A1415",
    cursorln = "#142123",
    bg_visual = "#2B3030",

    fg = "#e3faf4",
    fg_dim = "#a5c4ba",
    comment = "#568271",
    number_fg = "#3A4A4B",

    type_fg = "#89B497",
    string_fg = "#82A2BE",
    keyword = "#F6A97A",
    operator = "#BAD560",
    function_fg = "#9DCEE8",
    member_fg = "#91C4C0",
    constant = "#ffd7aa",

    border = "#89B497",
    separator = "#142123",

    git_add = "#86efac",
    git_change = "#fbbf24",
    git_delete = "#f43f5e",
  },

  -- Spazzed / Thorn-Violet: Gilded Obsidian & Royal Amethyst
  violet = {
    name = "thorn-violet",
    -- Dark purple molded and diluted with warm gold/bronze undertone:
    bg = "#120D18", -- Gilded dark obsidian velvet canvas (L ≈ 6.5%)
    bg_nc = "#0D0912", -- Deep inactive split void
    bg_float = "#1A1322", -- Warm elevated floating panels & popups
    cursorln = "#1E1628", -- Subtle active cursorline glow
    bg_visual = "#3A2257", -- User seed: Lite Royal-Purple selection highlight

    fg = "#EAE3F2", -- Soft warm lavender-pearl text (WCAG AAA 15.3:1)
    fg_dim = "#B8A7CB", -- Muted wisteria secondary text
    comment = "#826F98", -- Atmospheric dusty amethyst comments (WCAG AA 4.3:1)
    number_fg = "#423254", -- Muted plum gutter line numbers

    -- Gilded Warmth & Harmonious Syntax Spectrum
    keyword = "#F4AF6A", -- Warm Amber Gold (keywords, statements, imports)
    constant = "#F7D58B", -- Luminous Champagne Gold (constants, numbers, readonly)
    string_fg = "#DEC586", -- Warm Golden Wheat (strings)
    type_fg = "#C29BEA", -- Soft Lilac Orchid (types, interfaces, structs)
    function_fg = "#A4B8E6", -- Celestial Periwinkle Iris (functions, calls)
    operator = "#EAA098", -- Astonishing Warm Rose-Gold (replaces harsh red with refined elegance, 9.1:1 AAA)
    flow = "#F2A27E", -- Gilded Peach for return/control flow
    member_fg = "#C9B6E4", -- Ice Amethyst (members, fields, SQL columns)

    -- Accents & UI Frames
    border = "#46305C", -- Refined dark jewel purple border
    border_active = "#B88A3C", -- Secondary Gold active float border (straight from image)
    separator = "#1E1628", -- Subtle panel separator

    git_add = "#8FD4A8", -- Jade Mint (adds)
    git_change = "#E5B864", -- Topaz Gold (changes/warnings)
    git_delete = "#F44E6A", -- Jeweled Ruby (strictly for deletions/errors, not syntax text)
  },
}

--- Apply highlights for a given palette
---@param hl table Highlight table
---@param p table Palette table
function M.apply(hl, p)
  -- Core UI
  hl.Normal = { fg = p.fg, bg = p.bg }
  hl.NormalNC = { fg = p.fg, bg = p.bg_nc or p.bg }
  hl.NormalSB = { fg = p.fg, bg = p.bg }
  hl.NormalFloat = { fg = p.fg, bg = p.bg_float }

  hl.FloatBorder = { fg = p.border or p.type_fg, bg = p.bg_float }
  hl.FloatTitle = { fg = p.constant or p.type_fg, bg = p.bg_float, bold = true }

  -- Gutter
  hl.SignColumn = { fg = p.type_fg, bg = p.bg }
  hl.SignColumnSB = { fg = p.type_fg, bg = p.bg }
  hl.FoldColumn = { fg = p.comment, bg = p.bg }
  hl.LineNr = { fg = p.number_fg }
  hl.CursorLineNr = { fg = p.constant, bold = true }

  -- Cursor / Selection
  hl.CursorLine = { bg = p.cursorln }
  hl.CursorColumn = { bg = p.cursorln }
  hl.Visual = { bg = p.bg_visual }
  hl.VisualNOS = { bg = p.bg_visual }

  -- Standard Vim Syntax
  hl.Comment = { fg = p.comment }
  hl.Type = { fg = p.type_fg }
  hl.String = { fg = p.string_fg }
  hl.Keyword = { fg = p.keyword }
  hl.Statement = { fg = p.keyword }
  hl.Special = { fg = p.keyword }
  hl.Operator = { fg = p.operator }
  hl.Function = { fg = p.function_fg }
  hl.Identifier = { fg = p.fg }
  hl.Constant = { fg = p.constant }
  hl.Number = { fg = p.constant }
  hl.Boolean = { fg = p.constant }

  -- SQL
  hl.sqlKeyword = { fg = p.keyword }
  hl.sqlStatement = { fg = p.keyword }
  hl.sqlOperator = { fg = p.operator }
  hl.sqlFunction = { fg = p.function_fg }
  hl.sqlType = { fg = p.type_fg }
  hl.sqlString = { fg = p.string_fg }
  hl.sqlNumber = { fg = p.constant }
  hl.sqlComment = { fg = p.comment }

  -- Treesitter
  hl["@comment"] = { fg = p.comment }
  hl["@type"] = { fg = p.type_fg }
  hl["@type.builtin"] = { fg = p.type_fg }
  hl["@string"] = { fg = p.string_fg }
  hl["@string.documentation"] = { fg = p.string_fg }

  hl["@keyword"] = { fg = p.keyword }
  hl["@keyword.function"] = { fg = p.keyword }
  hl["@keyword.return"] = { fg = p.flow or p.keyword }
  hl["@keyword.conditional"] = { fg = p.keyword }
  hl["@keyword.repeat"] = { fg = p.keyword }
  hl["@keyword.import"] = { fg = p.keyword }
  hl["@keyword.exception"] = { fg = p.flow or p.keyword } -- try, catch, throw in gilded peach, not alarm red!

  hl["@operator"] = { fg = p.operator }

  hl["@function"] = { fg = p.function_fg }
  hl["@function.builtin"] = { fg = p.function_fg }
  hl["@function.call"] = { fg = p.function_fg }
  hl["@function.method"] = { fg = p.function_fg }
  hl["@function.method.call"] = { fg = p.function_fg }

  hl["@variable"] = { fg = p.fg }
  hl["@variable.builtin"] = { fg = p.constant }
  hl["@variable.parameter"] = { fg = p.constant }
  hl["@variable.member"] = { fg = p.member_fg }
  hl["@property"] = { fg = p.member_fg }
  hl["@field"] = { fg = p.member_fg }

  hl["@constant"] = { fg = p.constant }
  hl["@constant.builtin"] = { fg = p.constant }
  hl["@constructor"] = { fg = p.type_fg }

  -- LSP Semantic Tokens
  hl["@lsp.typemod.variable.readonly"] = { link = "@constant" }
  hl["@lsp.typemod.variable.static"] = { link = "@constant" }
  hl["@lsp.type.enumMember"] = { link = "@constant" }
  hl["@lsp.type.property"] = { link = "@property" }
  hl["@lsp.type.parameter"] = { link = "@variable.parameter" }

  -- Pmenu
  hl.Pmenu = { fg = p.fg, bg = p.bg_float }
  hl.PmenuSel = { fg = p.fg, bg = p.bg_visual, bold = true }
  hl.PmenuBorder = { fg = p.border or p.type_fg, bg = p.bg_float }

  -- Inlay hints
  hl.LspInlayHint = { fg = p.comment, bg = "NONE" }

  -- Git / Diagnostics
  hl.GitSignsAdd = { fg = p.git_add }
  hl.GitSignsChange = { fg = p.git_change }
  hl.GitSignsDelete = { fg = p.git_delete }
  hl.DiagnosticError = { fg = p.git_delete }
  hl.DiagnosticWarn = { fg = p.git_change }
  hl.DiagnosticInfo = { fg = p.function_fg }
  hl.DiagnosticHint = { fg = p.type_fg }
end

return M
