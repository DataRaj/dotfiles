-- ── delphinus/md-render.nvim: Markdown rendering with Mermaid & PlantUML ─────
-- Features:
--   - Inline images & diagrams via Kitty Graphics Protocol (Ghostty / Kitty / WezTerm)
--   - Mermaid diagrams rendered inline via mmdc / npx
--   - PlantUML diagrams rendered inline via configured server
--   - Tables with box-drawing borders, callouts, foldable blocks (<CR> / za)
--   - Live sync source/render split (:MdRender split)

return {
  {
    "delphinus/md-render.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    cmd = { "MdRender" },
    keys = {
      { "<leader>mp", "<Plug>(md-render-preview)", desc = "Markdown: Floating preview" },
      { "<leader>ms", "<cmd>vert MdRender split<cr>", desc = "Markdown: Live vertical split preview" },
      { "<leader>mr", "<Plug>(md-render-toggle)", desc = "Markdown: Toggle render in-place" },
      { "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown: Tab preview" },
      { "<leader>ma", "<Plug>(md-render-auto)", desc = "Markdown: Auto-render outside insert" },
      { "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown: Syntax & Diagram demo" },
    },
    init = function()
      -- Allow wide tables and diagrams to use up to 120 columns
      vim.g.md_render_max_width = 120
    end,
    config = function()
      -- Enable PlantUML rendering via PlantUML public server (cached locally)
      require("md-render.image").setup({
        plantuml_server = "https://www.plantuml.com/plantuml",
      })

      -- Initialize highlight groups
      require("md-render").setup_highlights()

      -- Label which-key group
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({
          { "<leader>m", group = "markdown" },
        })
      end
    end,
  },
}
