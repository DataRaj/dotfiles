return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
      -- show images inline in markdown, html
      doc = {
        enabled = true,
        inline = false, -- SAFE: on-demand float only, not auto-render
        float = true, -- also support float preview
      },
      -- file opener: show image when opening image file directly
      bo = { filetype = "image" },
    },
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = false,
        },
      },
      win = {
        input = {
          keys = {
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" }, desc = "Toggle hidden files" },
            ["<c-.>"] = { "toggle_hidden", mode = { "i", "n" }, desc = "Toggle hidden files" },
          },
        },
        list = {
          keys = {
            ["H"] = { "toggle_hidden", mode = { "n" }, desc = "Toggle hidden files" },
            ["<a-h>"] = { "toggle_hidden", mode = { "n" }, desc = "Toggle hidden files" },
          },
        },
      },
    },
  },
}
