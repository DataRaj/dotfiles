-- ── nvim-ufo: Modern code folding with fold-count badges and peek support ──────
-- Uses LSP → Treesitter → indent as provider chain.
-- Key behaviour:
--   zM           → Minimise (collapse) all code blocks
--   zR           → Expand (open) all code blocks
--   K            → Peek inside a folded block OR show LSP hover (same key)
--   za           → Toggle fold under cursor
--   zc / zo      → Close / Open fold under cursor

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      -- Provider chain: LSP is most accurate (understands imports, docstrings, functions).
      -- Falls back to treesitter (syntax-aware), then indent (universal).
      provider_selector = function(bufnr, filetype, buftype)
        -- Use only indent for special buffer types
        if buftype ~= "" then
          return "indent"
        end
        -- Per-language overrides: some LSPs don't send fold ranges
        local lsp_only = { "python", "typescript", "go", "lua", "rust" }
        for _, ft in ipairs(lsp_only) do
          if filetype == ft then
            return { "lsp", "treesitter" }
          end
        end
        return { "treesitter", "indent" }
      end,

      -- Virtual text shown on collapsed folds:
      -- e.g.  func ProcessOrder() {  ···  󰁂 48 lines }
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local foldedLines = endLnum - lnum
        local suffix = ("   󰁂 %d lines "):format(foldedLines)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- pad to align the suffix badge
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,

      -- Open folds by default when entering a buffer so nothing is hidden on open
      open_fold_hl_timeout = 400,
    },

    config = function(_, opts)
      -- These must be set BEFORE ufo setup so ufo can override foldexpr
      vim.opt.foldcolumn = "1"       -- 1-char gutter column showing fold arrows
      vim.opt.foldlevel = 99         -- Files open fully expanded
      vim.opt.foldlevelstart = 99    -- Start each buffer fully expanded
      vim.opt.foldenable = true      -- Enable folding
      vim.opt.foldnestmax = 6        -- Max nesting depth tracked

      require("ufo").setup(opts)
    end,

    keys = {
      -- Minimise / expand all
      {
        "zM",
        function() require("ufo").closeAllFolds() end,
        desc = "Fold: Minimise all blocks",
      },
      {
        "zR",
        function() require("ufo").openAllFolds() end,
        desc = "Fold: Expand all blocks",
      },
      -- Open one level at a time
      {
        "zr",
        function() require("ufo").openFoldsExceptKinds({ "comment" }) end,
        desc = "Fold: Open one level (skip comments)",
      },
      -- Close one level at a time
      {
        "zm",
        function() require("ufo").closeFoldsWith() end,
        desc = "Fold: Close one level",
      },
      -- Peek into a fold WITHOUT opening it, or fall back to LSP hover
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold / LSP hover",
      },
    },
  },
}
