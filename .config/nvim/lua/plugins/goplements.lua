-- ── goplements.nvim: Inline Go Struct & Interface Implementation Lens ────────
-- Uses Treesitter + gopls (`textDocument/implementation`) to render inline
-- virtual text next to `struct` and `interface` declarations:
--   - `type Reader interface` -> `󰟓 implemented by: FileReader, MockReader`
--   - `type FileReader struct` -> `󰟓 implements: Reader, io.Closer`

return {
  {
    "maxandron/goplements.nvim",
    ft = "go",
    cmd = {
      "GoplementsEnable",
      "GoplementsDisable",
      "GoplementsToggle",
    },
    keys = {
      {
        "<leader>ugi",
        "<cmd>GoplementsToggle<cr>",
        ft = "go",
        desc = "Toggle Go Implementations Virtual Text (Goplements)",
      },
      {
        "<leader>cgi",
        "<cmd>GoplementsToggle<cr>",
        ft = "go",
        desc = "Toggle Go Implementations Lens (Goplements)",
      },
    },
    opts = {
      prefix = {
        interface = "󰟓 implemented by: ",
        struct = "󰟓 implements: ",
      },
      display_package = true,
      namespace_name = "goplements",
      highlight = "Goplements",
    },
    config = function(_, opts)
      local function apply_goplements_hl()
        local is_light = vim.o.background == "light" or vim.g.colors_name == "thorn-light"
        if is_light then
          vim.api.nvim_set_hl(0, "Goplements", {
            fg = "#4D7A6E",
            italic = true,
          })
        else
          vim.api.nvim_set_hl(0, "Goplements", {
            fg = "#568270",
            italic = true,
          })
        end
      end

      apply_goplements_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("GoplementsHighlight", { clear = true }),
        callback = apply_goplements_hl,
      })

      require("goplements").setup(opts)
    end,
  },
}
