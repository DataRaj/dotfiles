-- ══════════════════════════════════════════════════════════════════════════════
-- GitHub Copilot  (Pro plan)
-- ══════════════════════════════════════════════════════════════════════════════
-- Stack:
--   • zbirenbaum/copilot.lua     — pure-Lua Copilot client (no Node extension)
--   • fang2hou/blink-copilot     — first-class blink.cmp source for suggestions
--   • CopilotC-Nvim/CopilotChat  — inline AI chat panel (explain, fix, review…)
--
-- ── Quick toggles:
--   <M-c>        Toggle Copilot inline suggestions ON/OFF  (insert + normal)
--   <leader>Ct   Same toggle, normal-mode only
--   <leader>Cs   Show :Copilot status
--
-- ── Inline suggestion keys  (in insert mode, when a ghost suggestion is visible):
--   <Tab>        Accept the full suggestion
--   <M-Right>    Accept only the next word
--   <M-]>        Cycle to next suggestion
--   <M-[>        Cycle to previous suggestion
--   <C-]>        Dismiss current suggestion
-- ══════════════════════════════════════════════════════════════════════════════

return {
  -- ─────────────────────────────────────────────────────────────────────────
  -- 1.  Core Copilot client
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- Panel (legacy :Copilot panel) — kept for the status command.
      panel = { enabled = false },

      -- Inline ghost-text suggestions — the blink source drives accept,
      -- so we disable the built-in <Tab> suggestion mapping here and remap
      -- manually below to avoid double-binding conflicts.
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true, -- hides ghost-text while blink popup is open
        debounce = 75,
        keymap = {
          -- Accept full suggestion
          accept = "<Tab>",
          -- Accept just the next word
          accept_word = "<M-Right>",
          -- Accept until end of line
          accept_line = false,
          -- Cycle suggestions
          next = "<M-]>",
          prev = "<M-[>",
          -- Dismiss
          dismiss = "<C-]>",
        },
      },

      -- Filetypes where Copilot is disabled by default.
      -- Extend this list with anything sensitive.
      filetypes = {
        help = false,
        gitcommit = true,    -- useful to have it in commit messages
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,       -- hidden dot-files that don't have a real ft
      },

      -- Node.js path — leave empty to auto-detect.
      copilot_node_command = "node",

      -- Extra server opts forwarded verbatim.
      server_opts_overrides = {},
    },

    config = function(_, opts)
      require("copilot").setup(opts)

      -- ── which-key group label ─────────────────────────────────────────
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({ { "<leader>C", group = "Copilot" } })
      end

      -- ── Shared toggle (global, works from Insert and Normal mode) ─────────
      local function toggle_copilot()
        if vim.g.copilot_enabled == false then
          vim.g.copilot_enabled = true
          vim.cmd("Copilot enable")
          vim.notify(" Copilot ON", vim.log.levels.INFO, { title = "Copilot" })
        else
          vim.g.copilot_enabled = false
          vim.cmd("Copilot disable")
          vim.notify("✗ Copilot OFF", vim.log.levels.WARN, { title = "Copilot" })
        end
      end

      -- <M-c>  — one-key toggle reachable from Insert AND Normal mode
      vim.keymap.set({ "n", "i" }, "<M-c>", toggle_copilot,
        { desc = "Copilot: Toggle inline suggestions" })

      -- <leader>Ct — normal-mode leader variant
      vim.keymap.set("n", "<leader>Ct", toggle_copilot,
        { desc = "Copilot: Toggle (buffer)" })

      -- ── Status ────────────────────────────────────────────────────────
      vim.keymap.set("n", "<leader>Cs", "<cmd>Copilot status<cr>", { desc = "Copilot: Status" })
    end,
  },


  -- ─────────────────────────────────────────────────────────────────────────
  -- 2.  blink.cmp source — surfaces Copilot suggestions inside the popup
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "fang2hou/blink-copilot",
    -- loaded on-demand by blink.cmp; no separate lazy event needed.
  },

  -- ─────────────────────────────────────────────────────────────────────────
  -- 3.  Wire the source into blink.cmp
  -- ─────────────────────────────────────────────────────────────────────────
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = function(_, opts)
      -- Ensure the sources table exists.
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Add copilot as a default source at the front.
      -- It will appear above LSP/snippet items unless you change `score_offset`.
      if not vim.tbl_contains(opts.sources.default, "copilot") then
        table.insert(opts.sources.default, 1, "copilot")
      end

      -- Register the provider.
      opts.sources.providers.copilot = {
        name = "Copilot",
        module = "blink-copilot",
        score_offset = 100, -- float Copilot items to the very top
        async = true,
        opts = {
          -- Show a distinctive icon next to Copilot items.
          kind_icon = " ",
          -- Max number of inline suggestions shown in the popup.
          max_completions = 3,
          -- Keep showing ghost text even while the popup is open.
          show_inline_with_autocomplete = false,
        },
      }

      return opts
    end,
  },
}
