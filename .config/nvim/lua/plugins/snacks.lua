-- lua/plugins/snacks-image.lua
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
  },
}
