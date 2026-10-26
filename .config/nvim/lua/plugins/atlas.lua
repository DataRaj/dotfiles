-- ── atlas.nvim: Unified PR review, issue tracking, and CI pipelines in Neovim ─
-- Manages GitHub PRs and issues without leaving the editor.
-- Docs: https://github.com/emrearmagan/atlas.nvim
--
-- Requirements (pre-verified):
--   ✓ Neovim 0.10+   (running 0.13.0)
--   ✓ git, curl      (system)
--   ✓ gh CLI         (authenticated as DataRaj via keyring)
--
-- Optional dependencies:
--   ✓ codediff.nvim  (already installed at lua/plugins/codediff.lua)
--     → used as the diff viewer for PR reviews

return {
  {
    "emrearmagan/atlas.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- icons in the dashboard
      "esmuellert/codediff.nvim",    -- PR diff viewer (already in your config)
    },
    -- Lazy-load: only when an Atlas command is called
    cmd = { "Atlas" },
    -- Top-level keymaps to open Atlas from anywhere
    keys = {
      { "<leader>gP", "<cmd>Atlas pulls .<cr>",  desc = "Atlas: Pull Requests (this repo)" },
      { "<leader>gI", "<cmd>Atlas issues .<cr>",  desc = "Atlas: Issues (this repo)" },
      { "<leader>gR", "<cmd>Atlas review .<cr>",  desc = "Atlas: Review current branch PR" },
      { "<leader>gB", "<cmd>Atlas browse .<cr>",  desc = "Atlas: Browse repository" },
      { "<leader>gN", "<cmd>Atlas pipelines .<cr>", desc = "Atlas: CI Pipelines" },
    },
    ---@type AtlasConfig
    opts = {
      ui = {
        -- Keep your existing statusline (lualine) — don't let atlas override it
        statusline = {
          atlas = false,
          diff  = false,
        },
        -- Use snacks.nvim picker (already in your setup) for provider selection
        picker = "snacks",
        -- Don't litter the buffer list with the Atlas dashboard
        listed_buffer = false,
      },

      providers = {
        -- GitHub: uses gh CLI credentials (no token needed in config)
        github = {
          -- hostname = "github.com",  -- default; change for GHE
          cache_ttl = 300, -- 5 minutes
        },
      },

      pulls = {
        -- Use codediff.nvim (already installed) for diff views
        diff = {
          open_cmd = "auto", -- auto-detects codediff since it's loaded
          comment_display = "virtual_lines",
          review_panel = {
            hidden = false,
            height = 12,
          },
          -- Side-by-side feels better for code review
          layout  = "side-by-side",
          compact = true, -- show only changed hunks
          explorer = {
            grouped       = true,
            hidden        = false,
            show_commits  = false,
            width         = 40,
            initial_focus = "explorer",
            preview       = false,
          },
        },

        -- GitHub-specific dashboard views
        github = {
          views = {
            {
              name   = "Mine",
              key    = "1",
              layout = "compact",
              search = "author:@me is:open sort:updated-desc",
            },
            {
              name   = "Review Requested",
              key    = "2",
              layout = "compact",
              search = "review-requested:@me is:open sort:updated-desc",
            },
            {
              name   = "All Open",
              key    = "3",
              layout = "grouped",
              search = "is:pr is:open sort:updated-desc",
            },
          },
          bookmarks = {
            key   = "S",
            label = "Quick Filters",
            items = {
              ["My Drafts"]        = "is:pr is:draft author:@me",
              ["Recently Merged"]  = "is:pr is:merged author:@me sort:updated-desc",
              ["Needs My Review"]  = "is:pr is:open review-requested:@me",
            },
          },
        },
      },

      issues = {
        with_relationships = true,
        github = {
          views = {
            {
              name   = "My Issues",
              key    = "1",
              layout = "compact",
              search = "author:@me is:open sort:updated-desc",
            },
            {
              name   = "Assigned to Me",
              key    = "2",
              layout = "plain",
              search = "assignee:@me is:open sort:updated-desc",
            },
          },
        },
      },
    },
  },
}
