# Reading Neovim Keymaps: The Notation Decoder

> [!NOTE]
> Neovim keymaps use a special notation inside angle brackets `< >` to represent keys that don't have a single printable character. Once you learn the 5 patterns below, you can read any keymap config blindfolded.

---

## The 5 Core Patterns

### Pattern 1: Modifier Keys  `<M-key>`

These are keys held **simultaneously** with another key.

| Notation | Means | English reading |
|----------|-------|-----------------|
| `<C-p>` | **Ctrl** + `p` | "Control P" |
| `<C-s>` | **Ctrl** + `s` | "Control S" (Save in your config) |
| `<A-j>` | **Alt** + `j` | "Alt J" (Alt = Option on Mac) |
| `<M-j>` | **Meta/Alt** + `j` | Same as `<A-j>` — `M` and `A` both mean Alt |
| `<S-Tab>` | **Shift** + `Tab` | "Shift Tab" |
| `<C-S-Tab>` | **Ctrl + Shift** + `Tab` | "Control Shift Tab" |

> [!TIP]
> **Memory trick:** `C` = Ctrl, `A` = Alt, `M` = Meta (same as Alt), `S` = Shift

---

### Pattern 2: Special Named Keys

These are keys that have a name because they don't produce a visible character.

| Notation | Physical key |
|----------|-------------|
| `<CR>` or `<Enter>` | Enter / Return key |
| `<Esc>` | Escape key |
| `<Tab>` | Tab key |
| `<BS>` | Backspace |
| `<Del>` | Delete key |
| `<Space>` | Spacebar |
| `<Up>` `<Down>` `<Left>` `<Right>` | Arrow keys |
| `<F1>` … `<F12>` | Function keys |
| `<Home>` `<End>` | Home / End |
| `<PageUp>` `<PageDown>` | Page Up / Down |

**Combined examples from your config:**
- `<A-Up>` = **Alt + Up Arrow** (you have this for moving lines up)
- `<C-BS>` = **Ctrl + Backspace** (delete word backward)
- `<S-A-Down>` = **Shift + Alt + Down** (clone line down)

---

### Pattern 3: Leader Key  `<leader>`

The `<leader>` key is a **prefix** key — a personal namespace for your custom shortcuts.

In LazyVim (and your config), it defaults to `Space`.

```lua
-- So this:
vim.keymap.set("n", "<leader>ff", ...)
-- Means: press Space, then f, then f
-- That's:  SPC f f
```

You'll see `<leader>` used as the first key of virtually every custom mapping. Think of it as your own command prefix that avoids clashing with Neovim's built-in keys.

---

### Pattern 4: Combined Modifiers + Named Keys

```
<C-Tab>    →  Ctrl + Tab
<A-Left>   →  Alt + Left Arrow
<S-Tab>    →  Shift + Tab
<C-CR>     →  Ctrl + Enter
```

These combine patterns 1 and 2. Read left to right: modifier(s) first, then the key.

---

### Pattern 5: Special Variables

| Notation | Meaning |
|----------|---------|
| `<leader>` | Your leader key (Space by default) |
| `<localleader>` | Local leader (often `\`, per-filetype) |
| `<Plug>` | Internal plugin reference (don't type this) |
| `<Cmd>` | Run a Vim command without leaving current mode |
| `<C-r>` | Ctrl+R (insert register contents in insert/command mode) |

---

## Reading a Full Keymap Line

Here's a real line from your [`keymaps.lua`](file:///home/dataraj/.config/nvim/lua/config/keymaps.lua):

```lua
vim.keymap.set("n", "<A-Up>", "<Cmd>m .-2<CR>==", { desc = "Move line up" })
```

Breaking it apart:

| Part | Meaning |
|------|---------|
| `"n"` | **Mode:** Normal mode only |
| `"<A-Up>"` | **Trigger:** Alt + Up Arrow |
| `"<Cmd>m .-2<CR>=="` | **Action:** Run `:m .-2` (move line up), press Enter, then `==` (re-indent) |
| `desc = "Move line up"` | **Description:** Shows in which-key popup |

---

## Mode Codes

The first argument to `vim.keymap.set` is the mode (or a list of modes):

| Code | Mode |
|------|------|
| `"n"` | **Normal** mode (navigating) |
| `"i"` | **Insert** mode (typing) |
| `"v"` | **Visual** mode (selection, both char and line) |
| `"x"` | **Visual** mode only (excludes Select mode) |
| `"s"` | **Select** mode |
| `"o"` | **Operator-pending** mode (e.g., after `d`, `y`, `c`) |
| `"c"` | **Command-line** mode (after `:`) |
| `"t"` | **Terminal** mode (inside `:terminal`) |
| `{ "n", "v" }` | Multiple modes at once |
| `""` | All modes (use rarely) |

---

## Reading Plugin Keymap Tables

In LazyVim-style plugins, keymaps are often declared in the `keys = {}` table:

```lua
{
  "some/plugin.nvim",
  keys = {
    { "<leader>pt", "<cmd>PluginToggle<cr>", desc = "Plugin: Toggle" },
    { "K", function() require("plugin").hover() end, desc = "Plugin: Hover" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
  },
}
```

Each entry is:  `{ trigger_key, action, mode = "n" (default), desc = "..." }`

- If no `mode` is given, it defaults to Normal mode `"n"`
- The action can be a string (Vim command) or a `function()`

---

## `<Cmd>` vs Regular Command Strings

You'll see two styles for running commands:

```lua
-- Style 1: <Cmd>...<CR>
"<Cmd>w<CR>"        -- Cmd mode (doesn't leave current mode, silent)

-- Style 2: :...Enter  (older style, inserts the ":" visually)
":w<CR>"            -- Visible in command line
```

`<Cmd>` is preferred in modern configs — it executes without mode side-effects.

---

## Common Patterns at a Glance

```
<leader>ff    →  Space f f    (find files)
<C-s>         →  Ctrl+S       (save)
<C-w>v        →  Ctrl+W then v  (vertical split)
<C-r><C-w>    →  Ctrl+R then Ctrl+W  (paste word in search)
<A-Up>        →  Alt+↑        (move line up)
<S-Tab>       →  Shift+Tab    (dedent / prev completion)
jk            →  j then k     (your escape alias in insert mode)
gj            →  g then j     (move down visual line, not real line)
```

---

## Your Config's Special Keys at a Glance

From [`keymaps.lua`](file:///home/dataraj/.config/nvim/lua/config/keymaps.lua):

| Keymap | What it does |
|--------|-------------|
| `jk` (insert) | Exit insert mode (your `<Esc>` alias) |
| `<C-s>` | Save file |
| `<C-a>` | Select all |
| `<leader>q` | Close buffer (layout-safe) ← **now fixed, `q` alone records macros** |
| `<C-Tab>` | Cycle buffers (MRU) |
| `<A-Up/Down>` | Move current line up/down |
| `<S-A-Down>` | Clone line down |
| `]p` / `[p` | Jump to next/prev bracket |
| `<leader>b` | Buffer picker |
| `<C-e>` | Close all floating windows |
| `n` / `N` | Search next/prev (centered, `nzzzv`) |

---

## The "Which-Key" Popup

When you press `<leader>` (Space) and pause, a popup shows all available keymaps. This is **which-key.nvim** (included in LazyVim). Use it — it's a living cheatsheet of every mapping you have.
