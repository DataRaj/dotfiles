# Disabled AI/Copilot Integration

All Copilot and auto-agents integrations have been disabled to improve performance.

## Disabled Files

1. **copilot.lua** - GitHub Copilot client and inline suggestions
2. **copilot-chat.lua** - CopilotChat.nvim AI pair-programming panel
3. **auto-agents.lua** - Auto-agents multi-agent orchestration panel

## Associated Disabled Dependencies

- `zbirenbaum/copilot.lua` - Pure-Lua Copilot client
- `fang2hou/blink-copilot` - blink.cmp source for Copilot
- `CopilotC-Nvim/CopilotChat.nvim` - Chat panel plugin
- `yongjohnlee80/auto-agents` - Multi-agent orchestration
- `coder/claudecode.nvim` - Claude Code TUI integration

## Modified Files

The following files were updated to remove references and integrations:

1. **lua/plugins/lualine.lua**
   - Removed: Copilot status pill from statusline
   - Commented code is preserved for re-enabling

2. **lua/plugins/snacks-terminals.lua**
   - Removed: auto-agents.nvim terminal ownership comments
   - Functionality: Snacks terminal style still works

3. **lua/utils/float_focus.lua**
   - Removed: auto-agents slot detection logic
   - Functionality: Snacks terminal auto-hide still works

4. **plugin/term_send.lua**
   - Disabled: TermSend command (required auto-agents)
   - Commented code is preserved for re-enabling

## How to Re-Enable

### Option 1: Re-enable Individual Components

#### Just Copilot (without chat or auto-agents):

```bash
# Move Copilot files back
cd ~/.config/nvim/lua/plugins
mv DISABLED_copilot/copilot.lua .

# Uncomment Copilot status in lualine
# Edit: lua/plugins/lualine.lua (uncomment the copilot_status section)
```

Then restart Neovim.

#### Just CopilotChat (requires copilot.lua first):

```bash
cd ~/.config/nvim/lua/plugins
mv DISABLED_copilot/copilot-chat.lua .
```

Then restart Neovim.

#### Just Auto-Agents (requires snacks.nvim):

```bash
cd ~/.config/nvim/lua/plugins
mv DISABLED_copilot/auto-agents.lua .

# Uncomment TermSend command
# Edit: plugin/term_send.lua (uncomment the vim.api.nvim_create_user_command block)

# Update lualine if desired
# Edit: lua/plugins/lualine.lua (uncomment the copilot_status section)

# Update float_focus.lua references if desired
# Edit: lua/utils/float_focus.lua (uncomment auto-agents specific logic)
```

Then restart Neovim.

### Option 2: Re-enable All Components

```bash
cd ~/.config/nvim/lua/plugins
mv DISABLED_copilot/copilot.lua .
mv DISABLED_copilot/copilot-chat.lua .
mv DISABLED_copilot/auto-agents.lua .

# Then uncomment sections in:
# - lua/plugins/lualine.lua
# - plugin/term_send.lua
# - lua/utils/float_focus.lua (optional)

# And update lazy-lock.json if needed
```

Then restart Neovim.

## Keymaps That Were Disabled

### Copilot Keymaps
- `<M-c>` - Toggle Copilot inline suggestions ON/OFF
- `<leader>Ct` - Toggle Copilot (buffer)
- `<leader>Cs` - Show Copilot status
- `<Tab>` - Accept full suggestion (insert mode)
- `<M-Right>` - Accept next word (insert mode)
- `<M-]>` - Cycle to next suggestion (insert mode)
- `<M-[>` - Cycle to previous suggestion (insert mode)
- `<C-]>` - Dismiss suggestion (insert mode)

### CopilotChat Keymaps
- `<leader>Cp` - Open/toggle chat panel
- `<leader>Cq` - Quick-ask
- `<leader>CC` - Clear conversation
- `<leader>Ce` - Explain code
- `<leader>Cf` - Fix code
- `<leader>Cr` - Code review
- `<leader>Co` - Optimize code
- `<leader>Cd` - Generate documentation
- `<leader>CT` - Generate tests

### Auto-Agents Keymaps
- `<leader>a` - AI / Auto Agents group
- `<leader>ac` - Toggle auto-agents panel
- `<leader>ap` - Auto-agents project commands
- `<leader>a0..9` - Focus slots 0-9
- `<F5>` - Toggle auto-agents panel
- `<F6>` - Auto-agents nav dock
- `<F12>` - Auto-agents nav dock

## Performance Impact

These integrations have been removed to improve Neovim startup and operation performance. If you don't actively use these features, leaving them disabled is recommended.

## Notes

- `lazy-lock.json` still contains these plugins' lock entries; they won't be installed as the plugin files are in `DISABLED_copilot/`
- Run `nvim` and use `:Lazy sync` if you want to clean up the unused plugins from your system
- All configurations are non-destructive; commented code can be restored by simply moving files back and uncommenting
