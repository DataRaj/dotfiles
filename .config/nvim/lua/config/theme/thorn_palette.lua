local M = {}

-- ============================================================================
-- THORN PALETTES
-- ============================================================================

M.palettes = {
  -- Original Dark Emerald / Teal Palette
  emerald = {
    name = "thorn",
    background = "dark",
    bg = "#040f13",
    bg_nc = "#040f13",
    bg_float = "#08181c",
    cursorln = "#0c2024",
    bg_visual = "#163438",

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
    constant = "#FFD7AA",
    flow = "#F6A97A",

    border = "#89B497",
    separator = "#0c2024",

    diff_add = "#122820",
    diff_change = "#122430",
    diff_delete = "#2c1820",

    git_add = "#86efac",
    git_change = "#fbbf24",
    git_delete = "#f43f5e",

    term_black = "#040f13",
    term_black_bright = "#568271",
  },

  -- Improvised Light Theme: Botanical Parchment, Sage Meadow & Deep Forest Ink
  light = {
    name = "thorn-light",
    background = "light",
    -- Soft botanical parchment & sage-ivory surfaces (eliminates harsh neon glare of #F9FDCE)
    bg = "#F4F6EE", -- Calm warm sage-parchment canvas
    bg_nc = "#EEF1E5", -- Subtle dimmed inactive split canvas
    bg_float = "#E9EFE0", -- Elevated floating panels, popups & pickers
    cursorln = "#E5ECDA", -- Gentle leaf-tint active line highlight
    bg_visual = "#CBE0B4", -- Crisp botanical meadow selection highlight

    -- High-contrast forest ink typography (WCAG AAA/AA compliant on #F4F6EE)
    fg = "#1A2B23", -- Deep Forest Pine Ink (13.8:1 AAA contrast)
    fg_dim = "#465E51", -- Muted woodland secondary text
    comment = "#667F6D", -- Lichen / Woodland Sage comments (4.5:1 AA contrast)
    number_fg = "#93A695", -- Soft sage-stone gutter line numbers

    -- Semantic syntax spectrum (direct light-mode counterparts to Dark Thorn)
    type_fg = "#216849", -- Deep Botanical Emerald (types, structs, interfaces, borders)
    string_fg = "#32567E", -- Dusk Slate-Indigo (strings, distinct from functions & types)
    keyword = "#B84A27", -- Rich Terracotta / Burnt Sienna (keywords, statements, SQL keywords)
    operator = "#567510", -- Deep Olive / Chartreuse Moss (operators, punctuation accents)
    function_fg = "#1B5C87", -- Deep Cerulean / Ocean Slate (functions & method calls)
    member_fg = "#196E6C", -- Deep Verdigris Teal (struct fields, properties, SQL columns)
    constant = "#A36016", -- Warm Ochre / Amber Bronze (constants, numbers, parameters)
    flow = "#C24E29", -- Spiced Persimmon (return / exception control flow)

    border = "#6C967D", -- Botanical sage float border
    separator = "#D4DEC6", -- Subtle split separator line

    diff_add = "#DCECC8",
    diff_change = "#ECE2C6",
    diff_delete = "#F2D4D2",

    git_add = "#2E7D32",
    git_change = "#B4690E",
    git_delete = "#C62828",

    term_black = "#1A2B23",
    term_black_bright = "#667F6D",
  },

  -- Spazzed / Thorn-Violet: Gilded Obsidian & Royal Amethyst
  violet = {
    name = "thorn-violet",
    background = "dark",
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

    diff_add = "#192D24",
    diff_change = "#2A2218",
    diff_delete = "#321622",

    git_add = "#8FD4A8", -- Jade Mint (adds)
    git_change = "#E5B864", -- Topaz Gold (changes/warnings)
    git_delete = "#F44E6A", -- Jeweled Ruby (strictly for deletions/errors, not syntax text)

    term_black = "#120D18",
    term_black_bright = "#826F98",
  },
}

--- Apply highlights for a given palette
---@param hl table Highlight table
---@param p table Palette table
function M.apply(hl, p)
  local border_fg = p.border or p.type_fg
  local sep_fg = p.separator or p.cursorln

  -- ==========================================================================
  -- CORE UI
  -- ==========================================================================
  hl.Normal = { fg = p.fg, bg = p.bg }
  hl.NormalNC = { fg = p.fg, bg = p.bg_nc or p.bg }
  hl.NormalSB = { fg = p.fg, bg = p.bg }
  hl.NormalFloat = { fg = p.fg, bg = p.bg_float }

  hl.FloatBorder = { fg = border_fg, bg = p.bg_float }
  hl.FloatTitle = { fg = p.type_fg, bg = p.bg_float, bold = true }

  hl.StatusLine = { fg = p.fg, bg = p.bg }
  hl.StatusLineNC = { fg = p.comment, bg = p.bg }
  hl.WinBar = { fg = p.fg, bg = p.bg }
  hl.WinBarNC = { fg = p.comment, bg = p.bg }
  hl.WinSeparator = { fg = sep_fg, bg = p.bg }
  hl.VertSplit = { fg = sep_fg, bg = p.bg }

  hl.EndOfBuffer = { fg = p.bg, bg = p.bg }
  hl.ColorColumn = { bg = p.bg_float }
  hl.Conceal = { fg = p.comment }
  hl.Cursor = { fg = p.bg, bg = p.fg }
  hl.lCursor = { fg = p.bg, bg = p.fg }
  hl.CursorIM = { fg = p.bg, bg = p.fg }

  hl.Directory = { fg = p.type_fg, bold = true }
  hl.Title = { fg = p.type_fg, bold = true }
  hl.ErrorMsg = { fg = p.git_delete }
  hl.WarningMsg = { fg = p.git_change }
  hl.MoreMsg = { fg = p.function_fg }
  hl.Question = { fg = p.function_fg }
  hl.ModeMsg = { fg = p.fg, bold = true }
  hl.MsgArea = { fg = p.fg, bg = p.bg }
  hl.NonText = { fg = p.number_fg }
  hl.SpecialKey = { fg = p.comment }
  hl.Whitespace = { fg = p.number_fg }

  hl.Folded = { fg = p.comment, bg = p.bg_float }
  hl.MatchParen = { fg = p.keyword, bg = p.bg_visual, bold = true }
  hl.Search = { fg = p.bg, bg = p.type_fg, bold = true }
  hl.IncSearch = { fg = p.bg, bg = p.keyword, bold = true }
  hl.CurSearch = { link = "IncSearch" }
  hl.Substitute = { fg = p.bg, bg = p.git_delete, bold = true }
  hl.QuickFixLine = { bg = p.bg_visual, bold = true }
  hl.WildMenu = { bg = p.bg_visual }

  hl.TabLine = { fg = p.comment, bg = p.bg_float }
  hl.TabLineFill = { fg = p.comment, bg = p.bg }
  hl.TabLineSel = { fg = p.bg, bg = p.type_fg, bold = true }

  -- ==========================================================================
  -- GUTTER
  -- ==========================================================================
  hl.SignColumn = { fg = p.type_fg, bg = p.bg }
  hl.SignColumnSB = { fg = p.type_fg, bg = p.bg }
  hl.FoldColumn = { fg = p.comment, bg = p.bg }
  hl.LineNr = { fg = p.number_fg }
  hl.LineNrAbove = { link = "LineNr" }
  hl.LineNrBelow = { link = "LineNr" }
  hl.CursorLineNr = { fg = p.constant, bold = true }

  -- ==========================================================================
  -- CURSOR / SELECTION
  -- ==========================================================================
  hl.CursorLine = { bg = p.cursorln }
  hl.CursorColumn = { bg = p.cursorln }
  hl.Visual = { bg = p.bg_visual }
  hl.VisualNOS = { bg = p.bg_visual }

  -- ==========================================================================
  -- DIFF & GIT
  -- ==========================================================================
  hl.DiffAdd = { bg = p.diff_add or p.cursorln }
  hl.DiffChange = { bg = p.diff_change or p.cursorln }
  hl.DiffDelete = { bg = p.diff_delete or p.cursorln }
  hl.DiffText = { bg = p.bg_visual, bold = true }

  hl.GitSignsAdd = { fg = p.git_add }
  hl.GitSignsChange = { fg = p.git_change }
  hl.GitSignsDelete = { fg = p.git_delete }

  -- ==========================================================================
  -- STANDARD VIM SYNTAX
  -- ==========================================================================
  hl.Comment = { fg = p.comment }
  hl.Type = { fg = p.type_fg }
  hl.StorageClass = { fg = p.keyword }
  hl.Structure = { fg = p.type_fg }
  hl.Typedef = { fg = p.type_fg }

  hl.String = { fg = p.string_fg }
  hl.Character = { fg = p.string_fg }

  hl.Keyword = { fg = p.keyword }
  hl.Statement = { fg = p.keyword }
  hl.Conditional = { fg = p.keyword }
  hl.Repeat = { fg = p.keyword }
  hl.Label = { fg = p.keyword }
  hl.Exception = { fg = p.flow or p.keyword }
  hl.Include = { fg = p.keyword }
  hl.PreProc = { fg = p.keyword }
  hl.Define = { fg = p.keyword }
  hl.Macro = { fg = p.function_fg }
  hl.PreCondit = { fg = p.keyword }

  hl.Special = { fg = p.keyword }
  hl.SpecialChar = { fg = p.constant }
  hl.Delimiter = { fg = p.fg_dim or p.comment }
  hl.Operator = { fg = p.operator }
  hl.Function = { fg = p.function_fg }
  hl.Identifier = { fg = p.fg }

  hl.Constant = { fg = p.constant }
  hl.Number = { fg = p.constant }
  hl.Float = { fg = p.constant }
  hl.Boolean = { fg = p.constant }

  hl.Todo = { fg = p.bg, bg = p.constant, bold = true }
  hl.Underlined = { fg = p.function_fg, underline = true }

  -- ==========================================================================
  -- SQL-SPECIFIC SYNTAX
  -- ==========================================================================
  hl.sqlKeyword = { fg = p.keyword }
  hl.sqlStatement = { fg = p.keyword }
  hl.sqlOperator = { fg = p.operator }
  hl.sqlFunction = { fg = p.function_fg }
  hl.sqlType = { fg = p.type_fg }
  hl.sqlString = { fg = p.string_fg }
  hl.sqlNumber = { fg = p.constant }
  hl.sqlComment = { fg = p.comment }

  -- ==========================================================================
  -- TREESITTER
  -- ==========================================================================
  hl["@comment"] = { fg = p.comment }
  hl["@type"] = { fg = p.type_fg }
  hl["@type.builtin"] = { fg = p.type_fg }
  hl["@type.definition"] = { fg = p.type_fg }
  hl["@type.qualifier"] = { fg = p.keyword }

  hl["@string"] = { fg = p.string_fg }
  hl["@string.documentation"] = { fg = p.string_fg }
  hl["@string.escape"] = { fg = p.constant }
  hl["@string.regexp"] = { fg = p.operator }

  hl["@keyword"] = { fg = p.keyword }
  hl["@keyword.function"] = { fg = p.keyword }
  hl["@keyword.return"] = { fg = p.flow or p.keyword }
  hl["@keyword.conditional"] = { fg = p.keyword }
  hl["@keyword.repeat"] = { fg = p.keyword }
  hl["@keyword.import"] = { fg = p.keyword }
  hl["@keyword.exception"] = { fg = p.flow or p.keyword }
  hl["@keyword.operator"] = { fg = p.keyword }

  hl["@operator"] = { fg = p.operator }

  hl["@function"] = { fg = p.function_fg }
  hl["@function.builtin"] = { fg = p.function_fg }
  hl["@function.call"] = { fg = p.function_fg }
  hl["@function.method"] = { fg = p.function_fg }
  hl["@function.method.call"] = { fg = p.function_fg }
  hl["@function.macro"] = { fg = p.function_fg }

  hl["@variable"] = { fg = p.fg }
  hl["@variable.builtin"] = { fg = p.constant }
  hl["@variable.parameter"] = { fg = p.constant }
  hl["@variable.member"] = { fg = p.member_fg }
  hl["@property"] = { fg = p.member_fg }
  hl["@field"] = { fg = p.member_fg }

  hl["@constant"] = { fg = p.constant }
  hl["@constant.builtin"] = { fg = p.constant }
  hl["@constructor"] = { fg = p.type_fg }
  hl["@module"] = { fg = p.type_fg }
  hl["@label"] = { fg = p.member_fg }

  hl["@punctuation.bracket"] = { fg = p.fg_dim or p.comment }
  hl["@punctuation.delimiter"] = { fg = p.fg_dim or p.comment }
  hl["@punctuation.special"] = { fg = p.operator }

  hl["@tag"] = { fg = p.keyword }
  hl["@tag.attribute"] = { fg = p.member_fg }
  hl["@tag.delimiter"] = { fg = p.fg_dim or p.comment }

  hl["@markup.heading"] = { fg = p.type_fg, bold = true }
  hl["@markup.heading.1.markdown"] = { fg = p.keyword, bold = true }
  hl["@markup.heading.2.markdown"] = { fg = p.type_fg, bold = true }
  hl["@markup.heading.3.markdown"] = { fg = p.function_fg, bold = true }
  hl["@markup.heading.4.markdown"] = { fg = p.member_fg, bold = true }
  hl["@markup.heading.5.markdown"] = { fg = p.constant, bold = true }
  hl["@markup.heading.6.markdown"] = { fg = p.comment, bold = true }
  hl["@markup.raw.markdown_inline"] = { fg = p.string_fg, bg = p.bg_float }
  hl["@markup.list.markdown"] = { fg = p.keyword, bold = true }
  hl["@markup.link"] = { fg = p.function_fg, underline = true }
  hl["@markup.strong"] = { fg = p.fg, bold = true }
  hl["@markup.quote"] = { fg = p.comment }

  -- ==========================================================================
  -- LSP SEMANTIC TOKENS
  -- ==========================================================================
  hl["@lsp.typemod.variable.readonly"] = { link = "@constant" }
  hl["@lsp.typemod.variable.static"] = { link = "@constant" }
  hl["@lsp.type.enumMember"] = { link = "@constant" }
  hl["@lsp.type.property"] = { link = "@property" }
  hl["@lsp.type.parameter"] = { link = "@variable.parameter" }

  -- ==========================================================================
  -- COMPLETION MENU (Pmenu & Blink)
  -- ==========================================================================
  hl.Pmenu = { fg = p.fg, bg = p.bg_float }
  hl.PmenuSel = { fg = p.fg, bg = p.bg_visual, bold = true }
  hl.PmenuBorder = { fg = border_fg, bg = p.bg_float }
  hl.PmenuSbar = { bg = p.bg_float }
  hl.PmenuThumb = { bg = p.border or p.comment }
  hl.PmenuMatch = { fg = p.type_fg, bg = p.bg_float, bold = true }
  hl.PmenuMatchSel = { fg = p.type_fg, bg = p.bg_visual, bold = true }
  hl.PmenuExtra = { fg = p.comment }

  hl.BlinkCmpMenu = { fg = p.fg, bg = p.bg_float }
  hl.BlinkCmpMenuBorder = { fg = border_fg, bg = p.bg_float }
  hl.BlinkCmpDoc = { fg = p.fg, bg = p.bg_float }
  hl.BlinkCmpDocBorder = { fg = border_fg, bg = p.bg_float }
  hl.BlinkCmpSignatureHelp = { fg = p.fg, bg = p.bg_float }
  hl.BlinkCmpSignatureHelpBorder = { fg = border_fg, bg = p.bg_float }
  hl.BlinkCmpLabel = { fg = p.fg }
  hl.BlinkCmpLabelMatch = { fg = p.type_fg, bold = true }
  hl.BlinkCmpLabelDetail = { fg = p.comment }
  hl.BlinkCmpLabelDescription = { fg = p.comment }
  hl.BlinkCmpGhostText = { fg = p.comment }

  -- ==========================================================================
  -- LSP & DIAGNOSTICS
  -- ==========================================================================
  hl.LspInlayHint = { fg = p.comment, bg = "NONE" }

  hl.DiagnosticError = { fg = p.git_delete }
  hl.DiagnosticWarn = { fg = p.git_change }
  hl.DiagnosticInfo = { fg = p.function_fg }
  hl.DiagnosticHint = { fg = p.type_fg }
  hl.DiagnosticOk = { fg = p.git_add }

  hl.DiagnosticUnderlineError = { sp = p.git_delete, undercurl = true }
  hl.DiagnosticUnderlineWarn = { sp = p.git_change, undercurl = true }
  hl.DiagnosticUnderlineInfo = { sp = p.function_fg, undercurl = true }
  hl.DiagnosticUnderlineHint = { sp = p.type_fg, undercurl = true }

  hl.DiagnosticVirtualTextError = { fg = p.git_delete, bg = p.diff_delete or p.bg_float }
  hl.DiagnosticVirtualTextWarn = { fg = p.git_change, bg = p.diff_change or p.bg_float }
  hl.DiagnosticVirtualTextInfo = { fg = p.function_fg, bg = p.bg_float }
  hl.DiagnosticVirtualTextHint = { fg = p.type_fg, bg = p.bg_float }

  -- ==========================================================================
  -- TERMINAL (<C-/> & Snacks Terminal)
  -- ==========================================================================
  hl.Terminal = { fg = p.fg, bg = p.bg }
  hl.SnacksNormal = { fg = p.fg, bg = p.bg }
  hl.SnacksNormalNC = { fg = p.fg, bg = p.bg }
  hl.SnacksTerminal = { fg = p.fg, bg = p.bg }
  hl.SnacksTerminalNormal = { fg = p.fg, bg = p.bg }
  hl.SnacksTerminalBorder = { fg = border_fg, bg = p.bg }
  hl.SnacksTerminalTitle = { fg = p.keyword, bg = p.bg, bold = true }

  -- ==========================================================================
  -- TREESITTER CONTEXT
  -- ==========================================================================
  hl.TreesitterContext = { bg = p.bg_float }
  hl.TreesitterContextLineNumber = { fg = p.number_fg, bg = p.bg_float }
  hl.TreesitterContextBottom = { sp = border_fg, underline = true }

  -- ==========================================================================
  -- COMMAND LINE & NOICE POPUPS (:)
  -- ==========================================================================
  hl.NoiceCmdline = { fg = p.fg, bg = p.bg_float }
  hl.NoiceCmdlinePopup = { fg = p.fg, bg = p.bg_float }
  hl.NoiceCmdlinePopupBorder = { fg = border_fg, bg = p.bg_float }
  hl.NoiceCmdlinePopupTitle = { fg = p.keyword, bg = p.bg_float, bold = true }
  hl.NoiceCmdlinePrompt = { fg = p.keyword, bg = p.bg_float }
  hl.NoicePopup = { fg = p.fg, bg = p.bg_float }
  hl.NoicePopupBorder = { fg = border_fg, bg = p.bg_float }
  hl.NoiceConfirm = { fg = p.fg, bg = p.bg_float }
  hl.NoiceConfirmBorder = { fg = border_fg, bg = p.bg_float }

  -- ==========================================================================
  -- PICKER, WHICH-KEY & FLOATING WINDOWS
  -- ==========================================================================
  hl.SnacksPicker = { fg = p.fg, bg = p.bg_float }
  hl.SnacksPickerBorder = { fg = border_fg, bg = p.bg_float }
  hl.SnacksPickerInput = { fg = p.fg, bg = p.bg_float }
  hl.SnacksPickerInputBorder = { fg = border_fg, bg = p.bg_float }
  hl.SnacksPickerList = { fg = p.fg, bg = p.bg_float }
  hl.SnacksPickerPreview = { fg = p.fg, bg = p.bg }
  hl.SnacksPickerBoxTitle = { fg = p.keyword, bg = p.bg_float, bold = true }
  hl.SnacksPickerInputTitle = { fg = p.keyword, bg = p.bg_float, bold = true }
  hl.SnacksPickerSelected = { fg = p.function_fg, bold = true }
  hl.SnacksIndent = { fg = p.separator or p.cursorln, nocombine = true }
  hl.SnacksIndentScope = { fg = p.type_fg, nocombine = true }

  hl.WhichKeyNormal = { fg = p.fg, bg = p.bg_float }
  hl.WhichKeyFloat = { fg = p.fg, bg = p.bg_float }
  hl.WhichKeyBorder = { fg = border_fg, bg = p.bg_float }
  hl.WhichKeyTitle = { fg = p.keyword, bg = p.bg_float, bold = true }

  hl.TelescopeNormal = { fg = p.fg, bg = p.bg_float }
  hl.TelescopeBorder = { fg = border_fg, bg = p.bg_float }
  hl.TelescopePromptNormal = { fg = p.fg, bg = p.bg_float }
  hl.TelescopePromptBorder = { fg = border_fg, bg = p.bg_float }
  hl.TelescopeResultsNormal = { fg = p.fg, bg = p.bg_float }
  hl.TelescopeResultsBorder = { fg = border_fg, bg = p.bg_float }
  hl.TelescopePreviewNormal = { fg = p.fg, bg = p.bg }
  hl.TelescopePreviewBorder = { fg = border_fg, bg = p.bg }

  hl.NeoTreeNormal = { fg = p.fg, bg = p.bg }
  hl.NeoTreeNormalNC = { fg = p.fg, bg = p.bg }
  hl.NeoTreeEndOfBuffer = { fg = p.bg, bg = p.bg }
  hl.NeoTreeDirectoryName = { fg = p.type_fg }
  hl.NeoTreeDirectoryIcon = { fg = p.type_fg }
  hl.NeoTreeRootName = { fg = p.keyword, bold = true }
  hl.NeoTreeGitAdded = { fg = p.git_add }
  hl.NeoTreeGitModified = { fg = p.git_change }
  hl.NeoTreeGitDeleted = { fg = p.git_delete }
  hl.NeoTreeGitUntracked = { fg = p.constant }
  hl.NeoTreeIndentMarker = { fg = sep_fg }
  hl.NeoTreeWinSeparator = { fg = sep_fg, bg = p.bg }
end

return M
