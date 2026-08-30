return {
  -- Load all theme plugins but don't apply them
  -- This ensures all colorschemes are available for hot-reloading
  {
    "ribru17/bamboo.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
  },
  {
    "kepano/flexoki-neovim",
    lazy = true,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tahayvr/matteblack.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "jpwol/thorn.nvim",
    name = "thorn",
    lazy = true,
    priority = 1000,
    opts = {
      -- style = "storm", -- or "moon", "night", "day"
      transparent = false, -- Try setting to true if tmux transparency causes issues
      terminal_colors = true, -- Ensure this is enabled
    },

    config = function()
      -- Kill italics after every colorscheme load
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local hl_groups = vim.fn.getcompletion("", "highlight")
          for _, group in ipairs(hl_groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            if hl.italic then
              hl.italic = false
              vim.api.nvim_set_hl(0, group, hl)
            end
          end
        end,
      })
      require("thorn").setup({
        -- ── Contrast overrides for "thorn" (forest / dark variant) ──────────
        -- These run AFTER the palette is applied, so nothing in the
        -- installed plugin files is modified — safe across :Lazy sync.
        on_highlights = function(hl, palette)
          -- ── Background: much darker base ──────────────────────────────────
          local bg = "#0D1A1B" -- was #172526 → richer, deeper black-green
          local bg_float = "#0A1415" -- popup/float bg (slightly darker still)
          local cursorln = "#142122" -- cursorline tint
          local bg_visual = "#1B3030" -- visual selection

          -- fg overridden to the requested #cdfae3 color
          local fg = "#dff7ef" -- user requested bright mint/white-ish color
          local comment = "#568270" -- ~40% brighter than original #568270

          -- ── Types: clear teal, clearly` distinct from identifiers ──────────
          local type_fg = "#88B497" -- bright mint-teal (was #88B497)

          -- ── Strings: warm light-green so they pop without screaming ───────
          local string_fg = "#81A2BE"

          -- ── Keywords / operators ──────────────────────────────────────────
          local keyword = "#F5A97A" -- warmer orange (was #F2A597)
          local operator = "#bad559" -- lifted red (was #D2696C)

          -- ── Line-nr gutter: legible but not intrusive ─────────────────────
          local number_fg = "#2A4A4B" -- a touch brighter than #1C3D3C

          -- Apply overrides ──────────────────────────────────────────────────
          -- Only bg is forced darker; fg stays as palette.fg
          hl.Normal = { fg = fg, bg = bg }
          hl.NormalNC = { fg = palette.fg, bg = bg }
          hl.NormalSB = { fg = palette.fg, bg = bg }
          hl.NormalFloat = { fg = palette.fg, bg = bg_float }
          hl.FloatBorder = { fg = type_fg, bg = bg_float }
          hl.FloatTitle = { fg = type_fg, bg = bg_float }

          -- Gutter columns: force same dark bg so no bright left-side strip
          hl.SignColumn = { fg = palette.green_5, bg = bg }
          hl.SignColumnSB = { fg = palette.green_5, bg = bg }
          hl.FoldColumn = { fg = palette.green_5, bg = bg }

          hl.CursorLine = { bg = cursorln }
          hl.CursorColumn = { bg = cursorln }
          -- ColorColumn removed — no override means it follows Normal bg cleanly
          hl.Visual = { bg = bg_visual }
          hl.VisualNOS = { bg = bg_visual }

          hl.Comment = { fg = comment }
          hl.LineNr = { fg = number_fg }
          hl.CursorLineNr = { fg = palette.yellow, bold = true }

          -- Syntax groups
          hl.Type = { fg = type_fg }
          hl.String = { fg = string_fg }
          hl.Keyword = { fg = keyword }
          hl.Statement = { fg = keyword }
          hl.Operator = { fg = operator }
          hl.Function = { fg = "#9DCEE8" }
          hl.Identifier = { fg = palette.green_0 }
          hl.Constant = { fg = palette.yellow }

          -- Treesitter
          hl["@comment"] = { fg = comment }
          hl["@type"] = { fg = type_fg }
          hl["@type.builtin"] = { fg = type_fg }
          hl["@string"] = { fg = string_fg }
          hl["@keyword"] = { fg = keyword }
          hl["@keyword.function"] = { fg = keyword }
          hl["@keyword.return"] = { fg = keyword }
          hl["@keyword.conditional"] = { fg = keyword }
          hl["@keyword.repeat"] = { fg = keyword }
          hl["@operator"] = { fg = operator }
          hl["@function"] = { fg = "#9DCEE8" }
          hl["@function.builtin"] = { fg = "#9DCEE8" }
          hl["@function.method"] = { fg = "#9DCEE8" }
          hl["@variable"] = { fg = fg }
          hl["@variable.parameter"] = { fg = palette.fg }
          hl["@constructor"] = { fg = type_fg }

          -- Popup menu
          hl.Pmenu = { bg = bg_float, fg = palette.fg }
          hl.PmenuSel = { bg = bg_visual, bold = true }
          hl.PmenuBorder = { fg = type_fg, bg = bg_float }

          -- Inlay hints: readable but clearly secondary
          hl.LspInlayHint = { fg = comment, bg = "NONE" }
        end,
      })
    end,
  },

  {
    "Koalhack/darcubox-nvim",
    name = "darcubox",
    lazy = true,
    priority = 1000,
    config = function()
      require("darcubox").setup({})
    end,
  },

  {
    "0xleodevv/oc-2.nvim",
    name = "oc-2",
    lazy = true,
    priority = 1000,
    config = function()
      require("oc2").setup({
        theme = "oc-2",
      })
    end,
  },

  {
    "sirzif/tzfn.nvim",
    name = "tzfn",
    lazy = true,
    priority = 1000,
    config = function()
      require("tzfn").setup({})
    end,
  },

  {
    "WTFox/luna.nvim",
    name = "luna",
    lazy = true,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "luna",
        callback = function()
          local gold_fg = "#f7ecab" -- Aesthetic whitish-gold / warm champagne tone
          vim.api.nvim_set_hl(0, "Normal", { fg = gold_fg })
          -- vim.api.nvim_set_hl(0, "NormalNC", { fg = gold_fg })
          -- vim.api.nvim_set_hl(0, "Identifier", { fg = gold_fg })
          -- vim.api.nvim_set_hl(0, "@variable", { fg = gold_fg })
          -- vim.api.nvim_set_hl(0, "@variable.parameter", { fg = gold_fg })
          -- vim.api.nvim_set_hl(0, "@variable.member", { fg = gold_fg })
        end,
      })
      require("luna").setup(opts)
    end,
  },
}
