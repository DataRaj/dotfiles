-- lua/config/keymaps.lua
-- VeryLazy event triggers these

-- ── Escape alias ─────────────────────────────────────────────────────────────
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ── Delete word backward in insert mode ──────────────────────────────────────
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
-- Some terminals send ^H for Ctrl+Backspace:
vim.keymap.set("i", "<C-h>", "<C-w>", { desc = "Delete word backward (^H)" })

-- ── Save ─────────────────────────────────────────────────────────────────────
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save file" })
vim.keymap.set("n", "<C-l>s", "<Cmd>w<CR>", { desc = "Save file (C-l s)" })

-- ── Select all ───────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("n", "<C-l>a", "ggVG", { desc = "Select all (C-l a)" })

-- ── Close buffer (q closes buffer, not window) ───────────────────────────────
-- Smart buffer-close: always switches to another buffer BEFORE calling :bd so
-- the underlying window split is never destroyed and Neo-tree can't expand.
-- Falls back to an empty buffer when no other listed buffer exists.
local function smart_close_buffer()
  local cur_buf = vim.api.nvim_get_current_buf()

  -- Ignore special/non-normal buffers (neo-tree, lazy, etc.)
  local cur_ft = vim.api.nvim_get_option_value("filetype", { buf = cur_buf })
  local skip_fts = { ["neo-tree"] = true, ["lazy"] = true, ["TelescopePrompt"] = true }
  if skip_fts[cur_ft] then return end

  -- Collect all listed, non-current buffers
  local listed = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b)
      and vim.bo[b].buflisted
      and b ~= cur_buf
  end, vim.api.nvim_list_bufs())

  -- Pick best target: prefer MRU order
  local target = nil
  if #listed > 0 then
    -- sort by lastused descending (most-recently-used first)
    local infos = vim.fn.getbufinfo({ buflisted = 1 })
    table.sort(infos, function(a, b) return a.lastused > b.lastused end)
    for _, info in ipairs(infos) do
      if info.bufnr ~= cur_buf then
        target = info.bufnr
        break
      end
    end
    if not target then target = listed[1] end
  end

  -- Switch every window showing this buffer to a safe target BEFORE deleting
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win)
      and vim.api.nvim_win_get_buf(win) == cur_buf then
      if target then
        vim.api.nvim_win_set_buf(win, target)
      else
        -- No other buffer: open a blank scratch buffer in this window
        vim.api.nvim_win_call(win, function() vim.cmd("enew") end)
      end
    end
  end

  -- Now safely wipe the original buffer (window split is already vacated)
  if vim.api.nvim_buf_is_valid(cur_buf) then
    pcall(vim.api.nvim_buf_delete, cur_buf, { force = false })
  end
end

vim.keymap.set("n", "q", smart_close_buffer, { desc = "Close buffer (layout-safe)" })

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUFFER NAVIGATION
-- ═══════════════════════════════════════════════════════════════════════════════

-- MRU buffer cycle (Alt+Tab style): step through buffers in recency order
-- Returns sorted list of listed, loaded buffer numbers (most-recent first)
local function mru_bufs()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  -- keep only loaded buffers (have been visited at least once)
  bufs = vim.tbl_filter(function(b) return b.loaded == 1 end, bufs)
  table.sort(bufs, function(a, b) return a.lastused > b.lastused end)
  local nums = {}
  for _, b in ipairs(bufs) do
    table.insert(nums, b.bufnr)
  end
  return nums
end

-- Step forward (+1) or backward (-1) through the MRU list
local function mru_cycle(dir)
  local bufs = mru_bufs()
  if #bufs < 2 then return end
  local cur = vim.api.nvim_get_current_buf()
  local idx = 1
  for i, nr in ipairs(bufs) do
    if nr == cur then idx = i; break end
  end
  local next_idx = ((idx - 1 + dir) % #bufs) + 1
  vim.api.nvim_set_current_buf(bufs[next_idx])
end

-- Ctrl+Tab  → next buffer in MRU order (most-recent → second-most-recent → …)
vim.keymap.set("n", "<C-Tab>", function() mru_cycle(1) end, { desc = "Next buffer (MRU)" })
-- Ctrl+Shift+Tab → previous (reverse through MRU list)
vim.keymap.set("n", "<C-S-Tab>", function() mru_cycle(-1) end, { desc = "Prev buffer (MRU)" })

-- <leader>b → buffer list picker (fuzzy, for when you want to search by name)
local function buf_picker()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.picker and type(snacks.picker.buffers) == "function" then
    snacks.picker.buffers({ sort_lastused = true, current_buf_first = false })
  else
    local tok, tel = pcall(require, "telescope.builtin")
    if tok then
      tel.buffers({ sort_mru = true, ignore_current_buffer = false })
    else
      vim.cmd("bnext")
    end
  end
end
vim.keymap.set("n", "<leader>b", buf_picker, { desc = "Buffer list (picker)" })

-- <leader><Tab>   → sequential next/prev (bufnr order, not MRU)
vim.keymap.set("n", "<leader><Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader><S-Tab>", "<Cmd>bprev<CR>", { desc = "Prev buffer" })

-- Legacy chord kept for muscle memory
vim.keymap.set("n", "<C-l><Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer (C-l Tab)" })

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. PARENTHESIS / BRACKET SECTION JUMPING  (like { } paragraph jumps)
--    ]] / [[ already jump between { in column-0 (functions).
--    ]p / [p jump between ANY paren/bracket/brace blocks.
-- ═══════════════════════════════════════════════════════════════════════════════

-- Jump to NEXT opening paren/bracket/brace
vim.keymap.set({ "n", "v" }, "]p", function()
  -- search forward for (, [, or {
  vim.fn.search([=[\(\|{\|\[]=], "W")
end, { desc = "Next paren/bracket" })

-- Jump to PREV opening paren/bracket/brace
vim.keymap.set({ "n", "v" }, "[p", function()
  vim.fn.search([=[\(\|{\|\[]=], "bW")
end, { desc = "Prev paren/bracket" })

-- Jump to NEXT closing paren/bracket/brace
vim.keymap.set({ "n", "v" }, "]P", function()
  vim.fn.search([=[\)\|}\|]]=], "W")
end, { desc = "Next closing paren/bracket" })

-- Jump to PREV closing paren/bracket/brace
vim.keymap.set({ "n", "v" }, "[P", function()
  vim.fn.search([=[\)\|}\|]]=], "bW")
end, { desc = "Prev closing paren/bracket" })

-- Ctrl+{ / Ctrl+} jump between paragraphs (explicit aliases — works in all modes)
vim.keymap.set({ "n", "v" }, "<C-{>", "{", { desc = "Prev paragraph" })
vim.keymap.set({ "n", "v" }, "<C-}>", "}", { desc = "Next paragraph" })

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. MOVE LINE(S) UP / DOWN
--    Alt+Up / Alt+Down  — works in Normal AND Visual (moves selection)
--    The classic :m trick; re-indent (==) after move to stay pretty.
-- ═══════════════════════════════════════════════════════════════════════════════

-- Normal mode: move current line
vim.keymap.set("n", "<A-Up>", "<Cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Down>", "<Cmd>m .+1<CR>==", { desc = "Move line down" })

-- Visual mode: move selection
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Insert mode: move current line (drops back to insert after move)
vim.keymap.set("i", "<A-Up>", "<Esc><Cmd>m .-2<CR>==gi", { desc = "Move line up (insert)" })
vim.keymap.set("i", "<A-Down>", "<Esc><Cmd>m .+1<CR>==gi", { desc = "Move line down (insert)" })

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. DELETE / CHANGE  from cursor to end-of-line OR to next paren
-- ═══════════════════════════════════════════════════════════════════════════════

--  D   = delete to end of line          (built-in, already works)
--  C   = change to end of line          (built-in, already works)
--  d)  = delete to next )               (built-in text-object motion, works)
--  c)  = change to next )               (same)

-- Convenience aliases so you don't have to hunt:
-- <leader>d( → delete from cursor to matching closing paren
vim.keymap.set("n", "<leader>d(", "dt)", { desc = "Delete till ) (exclusive)" })
vim.keymap.set("n", "<leader>d{", "dt}", { desc = "Delete till } (exclusive)" })
vim.keymap.set("n", "<leader>d[", "dt]", { desc = "Delete till ] (exclusive)" })

-- <leader>c( → change from cursor to matching closing paren (enter insert)
vim.keymap.set("n", "<leader>c(", "ct)", { desc = "Change till )" })
vim.keymap.set("n", "<leader>c{", "ct}", { desc = "Change till }" })
vim.keymap.set("n", "<leader>c[", "ct]", { desc = "Change till ]" })

-- Delete / change INSIDE the surrounding paren without having to type ci( etc.
-- These are the standard vim text objects, just documented here for reference:
--   di(  di{  di[  di"  di'  — delete inside
--   ci(  ci{  ci[  ci"  ci'  — change inside
--   da(  da{  da[         — delete around (including the brackets)
--   ca(  ca{  ca[         — change around

-- ── Delete without copying (black-hole register) ─────────────────────────────
-- Normal and Visual mode: deleting via `d`, `dd`, `di(`, `dw`, `D`, `x`, etc.
-- removes text without clobbering whatever you previously yanked/copied.
-- If an explicit register is supplied (e.g. "a or "+), it respects that register.
vim.keymap.set({ "n", "v" }, "d", function()
  return vim.v.register == '"' and '"_d' or "d"
end, { expr = true, desc = "Delete without copying" })

vim.keymap.set({ "n", "v" }, "D", function()
  return vim.v.register == '"' and '"_D' or "D"
end, { expr = true, desc = "Delete to EOL without copying" })

vim.keymap.set({ "n", "v" }, "x", function()
  return vim.v.register == '"' and '"_x' or "x"
end, { expr = true, desc = "Delete character without copying" })

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXTRA / QUALITY-OF-LIFE
-- ═══════════════════════════════════════════════════════════════════════════════

-- ── Clone line up / down ─────────────────────────────────────────────────────
vim.keymap.set("n", "<S-A-Down>", "<Cmd>t .<CR>", { desc = "Clone line down" })
vim.keymap.set("n", "<S-A-Up>", "<Cmd>t .-1<CR>", { desc = "Clone line up" })

-- ── Join line WITH the one above (inverse of J) ──────────────────────────────
vim.keymap.set("n", "<leader>J", "kJ", { desc = "Join with line above" })

-- ── Better n / N  (keep cursor centred after search jump) ────────────────────
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result (centred)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev result (centred)" })

-- ── Re-select last pasted text ────────────────────────────────────────────────
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select last pasted text" })

-- ── Indent / Dedent and stay in visual mode ───────────────────────────────────
vim.keymap.set("v", "<", "<gv", { desc = "Dedent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })

-- ── Insert mode cursor word moves (Alt+arrow) ────────────────────────────────
vim.keymap.set("i", "<A-Left>", "<C-Left>", { desc = "Word backward (insert)" })
vim.keymap.set("i", "<A-Right>", "<C-Right>", { desc = "Word forward (insert)" })

-- ── Add blank line above/below without entering insert mode ──────────────────
vim.keymap.set("n", "[<Space>", "<Cmd>put! =''<CR>", { desc = "Add blank line above" })
vim.keymap.set("n", "]<Space>", "<Cmd>put =''<CR>", { desc = "Add blank line below" })

-- ── Ctrl+E  close all floating windows / popups ──────────────────────────────
vim.keymap.set("n", "<C-e>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = "Close all floating windows" })

-- ── Window splits ────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-w>x", "<Cmd>split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<C-w>v", "<Cmd>vsplit<CR>", { desc = "Split vertical" })

-- ── Increment / Decrement number under cursor ─────────────────────────────────
-- Built-in Ctrl+A / Ctrl+X work; remap only if needed for insert mode:
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })
