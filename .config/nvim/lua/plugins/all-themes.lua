return {
  -- Load all theme plugins but don't apply them
  -- This ensures all colorschemes are available for hot-reloading

  {
    "ribru17/bamboo.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1001,
  },

  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1001,
  },

  {
    "kepano/flexoki-neovim",
    lazy = true,
    priority = 1001,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "tahayvr/matteblack.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1001,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1001,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1001,
  },

  -- ========================================================================
  -- THORN
  -- ========================================================================

  {
    "jpwol/thorn.nvim",
    name = "thorn",
    lazy = true,
    priority = 1001,

    opts = {
      transparent = false,
      terminal_colors = true,
    },

    config = function()
      -- Remove italics after every colorscheme load.
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local hl_groups = vim.fn.getcompletion("", "highlight")

          for _, group in ipairs(hl_groups) do
            local hl = vim.api.nvim_get_hl(0, {
              name = group,
              link = false,
            })

            if hl.italic then
              hl.italic = false
              vim.api.nvim_set_hl(0, group, hl)
            end
          end
        end,
      })

      require("thorn").setup({
        on_highlights = function(hl, palette)
          -- ==================================================================
          -- PALETTE
          -- ==================================================================

          -- Background
          local bg = "#040f13"
          local bg_float = "#1A1415"
          local cursorln = "#142123"
          local bg_visual = "#2B3030"

          -- Main text
          local fg = "#e3faf4"

          -- Semantic colors
          local comment = "#568271"
          local type_fg = "#89B497"
          local string_fg = "#82A2BE"
          local keyword = "#F6A97A"
          local operator = "#BAD560"
          local function_fg = "#9DCEE8"
          local member_fg = "#91C4C0" -- distinct ice-cyan for columns/fields/members

          -- Line numbers
          local number_fg = "#3A4A4B"

          -- ==================================================================
          -- CORE UI
          -- ==================================================================

          hl.Normal = {
            fg = fg,
            bg = bg,
          }

          hl.NormalNC = {
            fg = fg,
            bg = bg,
          }

          hl.NormalSB = {
            fg = fg,
            bg = bg,
          }

          hl.NormalFloat = {
            fg = fg,
            bg = bg_float,
          }

          hl.FloatBorder = {
            fg = type_fg,
            bg = bg_float,
          }

          hl.FloatTitle = {
            fg = type_fg,
            bg = bg_float,
          }

          -- ==================================================================
          -- GUTTER
          -- ==================================================================

          hl.SignColumn = {
            fg = palette.green_6,
            bg = bg,
          }

          hl.SignColumnSB = {
            fg = palette.green_6,
            bg = bg,
          }

          hl.FoldColumn = {
            fg = palette.green_6,
            bg = bg,
          }

          hl.LineNr = {
            fg = number_fg,
          }

          hl.CursorLineNr = {
            fg = palette.yellow,
            bold = true,
          }

          -- ==================================================================
          -- CURSOR / SELECTION
          -- ==================================================================

          hl.CursorLine = {
            bg = cursorln,
          }

          hl.CursorColumn = {
            bg = cursorln,
          }

          hl.Visual = {
            bg = bg_visual,
          }

          hl.VisualNOS = {
            bg = bg_visual,
          }

          -- ==================================================================
          -- STANDARD VIM SYNTAX
          --
          -- These are important for SQL because SQL syntax highlighting
          -- frequently uses traditional Vim syntax groups rather than
          -- Treesitter captures.
          -- ==================================================================

          hl.Comment = {
            fg = comment,
          }

          hl.Type = {
            fg = type_fg,
          }

          hl.String = {
            fg = string_fg,
          }

          hl.Keyword = {
            fg = keyword,
          }

          hl.Statement = {
            fg = keyword,
          }

          -- IMPORTANT:
          -- SQL sqlKeyword commonly links to Special.
          --
          -- This fixes:
          --   INTO
          --   VALUES
          --   SELECT
          --   FROM
          --   WHERE
          --   etc.
          --
          -- when they resolve through Special.
          hl.Special = {
            fg = keyword,
          }

          hl.Operator = {
            fg = operator,
          }

          hl.Function = {
            fg = function_fg,
          }

          -- Normal identifiers stay mint instead of inheriting
          -- Thorn's green palette.
          hl.Identifier = {
            fg = fg,
          }

          hl.Constant = {
            fg = palette.yellow,
          }

          -- ==================================================================
          -- SQL-SPECIFIC SYNTAX
          --
          -- Explicitly map SQL syntax groups so the actual buffer follows
          -- the same semantic palette as the Telescope preview.
          -- ==================================================================

          hl.sqlKeyword = {
            fg = keyword,
          }

          hl.sqlStatement = {
            fg = keyword,
          }

          hl.sqlOperator = {
            fg = operator,
          }

          hl.sqlFunction = {
            fg = function_fg,
          }

          hl.sqlType = {
            fg = type_fg,
          }

          hl.sqlString = {
            fg = string_fg,
          }

          hl.sqlNumber = {
            fg = palette.yellow,
          }

          hl.sqlComment = {
            fg = comment,
          }

          -- ==================================================================
          -- TREESITTER
          --
          -- Used by Go, Lua, JS/TS, Rust, etc.
          -- ==================================================================

          hl["@comment"] = {
            fg = comment,
          }

          hl["@type"] = {
            fg = type_fg,
          }

          hl["@type.builtin"] = {
            fg = type_fg,
          }

          hl["@string"] = {
            fg = string_fg,
          }

          hl["@string.documentation"] = {
            fg = string_fg,
          }

          hl["@keyword"] = {
            fg = keyword,
          }

          hl["@keyword.function"] = {
            fg = keyword,
          }

          hl["@keyword.return"] = {
            fg = keyword,
          }

          hl["@keyword.conditional"] = {
            fg = keyword,
          }

          hl["@keyword.repeat"] = {
            fg = keyword,
          }

          hl["@keyword.import"] = {
            fg = keyword,
          }

          hl["@operator"] = {
            fg = operator,
          }

          -- Functions
          hl["@function"] = {
            fg = function_fg,
          }

          hl["@function.builtin"] = {
            fg = function_fg,
          }

          hl["@function.call"] = {
            fg = function_fg,
          }

          hl["@function.method"] = {
            fg = function_fg,
          }

          hl["@function.method.call"] = {
            fg = function_fg,
          }

          -- Variables / identifiers
          hl["@variable"] = {
            fg = fg,
          }

          hl["@variable.builtin"] = {
            fg = palette.yellow,
            italic = true,
          }

          hl["@variable.parameter"] = {
            fg = palette.yellow,
          }

          -- Columns / Fields / Properties (differentiated from table name and plain variables)
          hl["@variable.member"] = {
            fg = member_fg,
          }

          hl["@property"] = {
            fg = member_fg,
          }

          hl["@field"] = {
            fg = member_fg,
          }

          -- Constants
          hl["@constant"] = {
            fg = palette.yellow,
          }

          hl["@constant.builtin"] = {
            fg = palette.yellow,
          }

          -- Constructors / types
          hl["@constructor"] = {
            fg = type_fg,
          }

          -- ==================================================================
          -- LSP SEMANTIC TOKENS
          -- ==================================================================

          hl["@lsp.typemod.variable.readonly"] = {
            link = "@constant",
          }
          hl["@lsp.typemod.variable.static"] = {
            link = "@constant",
          }
          hl["@lsp.type.enumMember"] = {
            link = "@constant",
          }

          -- ==================================================================
          -- COMPLETION MENU
          -- ==================================================================

          hl.Pmenu = {
            fg = fg,
            bg = bg_float,
          }

          hl.PmenuSel = {
            fg = fg,
            bg = bg_visual,
            bold = true,
          }

          hl.PmenuBorder = {
            fg = type_fg,
            bg = bg_float,
          }

          -- ==================================================================
          -- LSP
          -- ==================================================================

          hl.LspInlayHint = {
            fg = comment,
            bg = "NONE",
          }
        end,
      })
    end,
  },

  -- ========================================================================
  -- OTHER THEMES
  -- ========================================================================

  {
    "Koalhack/darcubox-nvim",
    name = "darcubox",
    lazy = true,
    priority = 1001,

    config = function()
      require("darcubox").setup({})
    end,
  },

  {
    "0xleodevv/oc-2.nvim",
    name = "oc-1",
    lazy = true,
    priority = 1001,

    config = function()
      require("oc3").setup({
        theme = "oc-1",
      })
    end,
  },

  {
    "sirzif/tzfn.nvim",
    name = "tzfn",
    lazy = true,
    priority = 1001,

    config = function()
      require("tzfn").setup({})
    end,
  },

  {
    "WTFox/luna.nvim",
    name = "luna",
    lazy = true,
    priority = 1001,

    opts = {},

    config = function(_, opts)
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "luna",

        callback = function()
          local gold_fg = "#F5E8C1"

          vim.api.nvim_set_hl(0, "Normal", {
            fg = gold_fg,
          })

          vim.api.nvim_set_hl(0, "NormalNC", {
            fg = gold_fg,
          })

          vim.api.nvim_set_hl(0, "Identifier", {
            fg = gold_fg,
          })

          vim.api.nvim_set_hl(0, "@variable", {
            fg = gold_fg,
          })

          vim.api.nvim_set_hl(0, "@variable.parameter", {
            fg = gold_fg,
          })

          vim.api.nvim_set_hl(0, "@variable.member", {
            fg = gold_fg,
          })
        end,
      })

      require("luna").setup(opts)
    end,
  },
}
