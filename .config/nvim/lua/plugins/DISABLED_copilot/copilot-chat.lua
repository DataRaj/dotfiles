-- ══════════════════════════════════════════════════════════════════════════════
-- CopilotChat.nvim  — AI pair-programming chat panel
-- ══════════════════════════════════════════════════════════════════════════════
-- Features used:
--   • Floating or split chat window triggered by keymaps
--   • Context-aware: sends visual selection, current buffer, or whole file
--   • Built-in slash-commands: /explain /fix /review /optimize /docs /tests
--   • Sticky system prompts that persist across the session
--   • Diff-view for suggested patches
--
-- Keymaps  (all under <leader>C):
--   Normal mode:
--     <leader>Cp   Open/toggle the chat panel (freeform)
--     <leader>Cq   Quick-ask (inline input → response in float)
--     <leader>CC   Clear / reset conversation
--
--   Visual mode (operates on selection):
--     <leader>Ce   Explain selected code
--     <leader>Cf   Fix the selected code
--     <leader>Cr   Code review with suggestions
--     <leader>Co   Optimise selection
--     <leader>Cd   Generate documentation
--     <leader>CT   Generate unit tests
-- ══════════════════════════════════════════════════════════════════════════════

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "*",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",

    opts = {
      -- ── Window style ────────────────────────────────────────────────────
      -- Using 'vertical' split avoids the "Invalid window id" crash that
      -- 'float' layout triggers when the originating window is closed while
      -- the overlay is still trying to restore it (overlay.lua:119).
      window = {
        layout = "vertical",    -- 'vertical' | 'horizontal' | 'float' | 'replace'
        width = 0.40,           -- fraction of editor width (vertical split)
      },

      -- ── Model & behaviour ────────────────────────────────────────────────
      -- Models available on Copilot Pro (fetched live via /models API).
      -- Run :CopilotChatModels inside Neovim to see your current list.
      model = "claude-sonnet-4-5", -- Claude Sonnet on Copilot Pro
      temperature = 0.1,        -- Low → more deterministic, code-focused answers.
      context = "buffer",       -- Default context: current buffer.
                                -- In visual mode it automatically switches to 'selection'.

      -- ── Sticky system prompt ─────────────────────────────────────────────
      -- Appended to every conversation. Adjust to your preferred style.
      system_prompt = [[
You are an expert software engineer and pair programmer.
When suggesting code:
  - Preserve the existing code style and indentation.
  - Use idiomatic patterns for the language.
  - Explain *why* the change is made, not just *what* it does.
  - If multiple approaches exist, briefly list trade-offs.
  - Be concise; avoid unnecessary filler text.
]],

      -- ── Diff display ─────────────────────────────────────────────────────
      show_diff = true,         -- shows a side-by-side diff when Copilot suggests changes
      show_info = true,
      show_context = true,

      -- ── Highlight source code in responses ───────────────────────────────
      highlight_headers = true,
      separator = "─",

      -- ── Auto-follow the latest response ──────────────────────────────────
      auto_follow_cursor = true,
      auto_insert_mode = false,  -- don't auto-enter insert inside the chat window

      -- ── Mappings inside the chat buffer ──────────────────────────────────
      -- '@' (agent/file context) and '#' (reference) are disabled here because
      -- they intercept normal navigation characters and make it awkward to move
      -- around the chat buffer. Use <C-f> for file context and <C-a> for agents.
      mappings = {
        complete = {
          detail = "Use <C-f> for file context, <C-a> for agent, / for prompts.",
          insert = "<C-Space>",  -- trigger context completions without hijacking Tab
        },
        close        = { normal = "q",    insert = "<C-c>" },
        reset        = { normal = "<C-r>", insert = "<C-r>" },
        submit_prompt = { normal = "<CR>",  insert = "<C-s>" },
        accept_diff  = { normal = "<C-y>", insert = "<C-y>" },
        yank_diff    = { normal = "gy" },
        show_diff    = { normal = "gd" },
        show_info    = { normal = "gi" },
        show_context = { normal = "gc" },
      },
    },

    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      -- ── Helper: run a named prompt; visual selection is auto-detected ──────
      local function run_prompt(p)
        return function() chat.ask(p, { selection = require("CopilotChat.select").visual }) end
      end

      -- ── Normal-mode keymaps ───────────────────────────────────────────────
      vim.keymap.set("n", "<leader>Cp", function() chat.toggle() end,
        { desc = "Copilot: Chat panel (toggle)" })

      vim.keymap.set("n", "<leader>Cq", function()
        local q = vim.fn.input("Copilot Ask: ")
        if q ~= "" then chat.ask(q) end
      end, { desc = "Copilot: Quick-ask" })

      vim.keymap.set("n", "<leader>CC", function() chat.reset() end,
        { desc = "Copilot: Clear conversation" })

      -- Buffer-level context shortcuts
      vim.keymap.set("n", "<leader>Ce", run_prompt("/Explain"),
        { desc = "Copilot: Explain (buffer)" })
      vim.keymap.set("n", "<leader>Cf", run_prompt("/Fix"),
        { desc = "Copilot: Fix issue (buffer)" })
      vim.keymap.set("n", "<leader>Cr", run_prompt("/Review"),
        { desc = "Copilot: Code review (buffer)" })
      vim.keymap.set("n", "<leader>Co", run_prompt("/Optimize"),
        { desc = "Copilot: Optimise (buffer)" })
      vim.keymap.set("n", "<leader>Cd", run_prompt("/Docs"),
        { desc = "Copilot: Generate docs (buffer)" })
      vim.keymap.set("n", "<leader>CT", run_prompt("/Tests"),
        { desc = "Copilot: Generate tests (buffer)" })

      -- ── Visual-mode keymaps — operate on selection ────────────────────────
      vim.keymap.set("v", "<leader>Ce", run_prompt("/Explain"),
        { desc = "Copilot: Explain selection" })
      vim.keymap.set("v", "<leader>Cf", run_prompt("/Fix"),
        { desc = "Copilot: Fix selection" })
      vim.keymap.set("v", "<leader>Cr", run_prompt("/Review"),
        { desc = "Copilot: Review selection" })
      vim.keymap.set("v", "<leader>Co", run_prompt("/Optimize"),
        { desc = "Copilot: Optimise selection" })
      vim.keymap.set("v", "<leader>Cd", run_prompt("/Docs"),
        { desc = "Copilot: Generate docs" })
      vim.keymap.set("v", "<leader>CT", run_prompt("/Tests"),
        { desc = "Copilot: Generate tests" })
      vim.keymap.set("v", "<leader>Cq", function()
        local q = vim.fn.input("Copilot Ask: ")
        if q ~= "" then
          chat.ask(q, { selection = require("CopilotChat.select").visual })
        end
      end, { desc = "Copilot: Ask about selection" })
    end,
  },
}
