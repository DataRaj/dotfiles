#!/usr/bin/env bash
# Toggle or apply Thorn Dark (`thorn`) <-> Thorn Light (`thorn-light`) across Tmux & Neovim.
# Usage:
#   tmux-theme-toggle.sh toggle   # Flips between thorn and thorn-light (Tmux + all Neovim instances)
#   tmux-theme-toggle.sh apply    # Applies current ~/.local/state/nvim/current-theme.txt to Tmux

set -u

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/nvim/current-theme.txt"
mkdir -p "$(dirname "$STATE_FILE")"

CURRENT="thorn"
if [[ -f "$STATE_FILE" ]]; then
  CURRENT="$(tr -d '[:space:]' < "$STATE_FILE")"
fi

ACTION="${1:-toggle}"

if [[ "$ACTION" == "toggle" ]]; then
  if [[ "$CURRENT" == "thorn-light" || "$CURRENT" == "thorn-field" ]]; then
    TARGET="thorn"
  else
    TARGET="thorn-light"
  fi
  printf '%s\n' "$TARGET" > "$STATE_FILE"
else
  TARGET="$CURRENT"
fi

if [[ "$TARGET" == "thorn-light" || "$TARGET" == "thorn-field" ]]; then
  # ── Thorn Light (Botanical Parchment, Sage Meadow & Deep Forest Ink) ────────
  tmux \
    set -g @thorn_mode "light" \; \
    set -g status-style "bg=#F4F6EE,fg=#1A2B23" \; \
    set -g status-left "#[fg=#F4F6EE,bg=#216849,bold]  #S #[fg=#216849,bg=#F4F6EE,nobold] " \; \
    set -g status-right "#[fg=#E2EAD6,bg=#F4F6EE]#[fg=#216849,bg=#E2EAD6]  #{b:pane_current_path} #[fg=#667F6D,bg=#E2EAD6]| #[fg=#1B5C87,bg=#E2EAD6] %H:%M #[fg=#E2EAD6,bg=#F4F6EE] #[fg=#B84A27,bg=#F4F6EE]#[fg=#F4F6EE,bg=#B84A27,bold]󰃭 %d-%b #[fg=#B84A27,bg=#F4F6EE]" \; \
    setw -g window-status-format "#[fg=#E5ECDA,bg=#F4F6EE]#[fg=#667F6D,bg=#E5ECDA]#I #[fg=#667F6D,bg=#E5ECDA]| #[fg=#216849,bg=#E5ECDA]#W#[fg=#E5ECDA,bg=#F4F6EE]" \; \
    setw -g window-status-current-format "#[fg=#CBE0B4,bg=#F4F6EE]#[fg=#B84A27,bg=#CBE0B4,bold]#I #[fg=#667F6D,bg=#CBE0B4]| #[fg=#1A2B23,bg=#CBE0B4,bold]#W#[fg=#CBE0B4,bg=#F4F6EE]" \; \
    set -g pane-border-style "fg=#D4DEC6,bg=default" \; \
    set -g pane-active-border-style "fg=#216849,bg=default" \; \
    set -g message-style "bg=#E2EAD6,fg=#1A2B23,bold" \; \
    set -g message-command-style "bg=#E2EAD6,fg=#216849" \; \
    setw -g mode-style "bg=#CBE0B4,fg=#1A2B23" 2>/dev/null || true
else
  # ── Thorn Dark (Deep Forest Emerald #040f13) ───────────────────────────────
  tmux \
    set -g @thorn_mode "dark" \; \
    set -g status-style "bg=#040f13,fg=#dff7ef" \; \
    set -g status-left "#[fg=#040f13,bg=#88B497,bold]  #S #[fg=#88B497,bg=#040f13,nobold] " \; \
    set -g status-right "#[fg=#1B3030,bg=#040f13]#[fg=#88B497,bg=#1B3030]  #{b:pane_current_path} #[fg=#568270,bg=#1B3030]| #[fg=#9DCEE8,bg=#1B3030] %H:%M #[fg=#1B3030,bg=#040f13] #[fg=#F5A97A,bg=#040f13]#[fg=#040f13,bg=#F5A97A,bold]󰃭 %d-%b #[fg=#F5A97A,bg=#040f13]" \; \
    setw -g window-status-format "#[fg=#142122,bg=#040f13]#[fg=#568270,bg=#142122]#I #[fg=#568270,bg=#142122]| #[fg=#88B497,bg=#142122]#W#[fg=#142122,bg=#040f13]" \; \
    setw -g window-status-current-format "#[fg=#1B3030,bg=#040f13]#[fg=#F5A97A,bg=#1B3030,bold]#I #[fg=#568270,bg=#1B3030]| #[fg=#dff7ef,bg=#1B3030,bold]#W#[fg=#1B3030,bg=#040f13]" \; \
    set -g pane-border-style "fg=#1B3030,bg=default" \; \
    set -g pane-active-border-style "fg=#88B497,bg=default" \; \
    set -g message-style "bg=#1B3030,fg=#dff7ef,bold" \; \
    set -g message-command-style "bg=#1B3030,fg=#88B497" \; \
    setw -g mode-style "bg=#1B3030,fg=#dff7ef" 2>/dev/null || true
fi

# When toggled from Tmux, also broadcast the new theme to all running Neovim instances
if [[ "$ACTION" == "toggle" ]]; then
  RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  for sock in "$RUNTIME_DIR"/nvim.*.0; do
    [[ -S "$sock" ]] || continue
    if [[ "$TARGET" == "thorn-light" ]]; then
      nvim --server "$sock" --remote-expr "execute('colorscheme thorn-light')" >/dev/null 2>&1 &
    else
      nvim --server "$sock" --remote-expr "execute('noautocmd set background=dark') . execute('colorscheme thorn')" >/dev/null 2>&1 &
    fi
  done
  tmux display-message "Theme switched to: ${TARGET}" 2>/dev/null || true
fi
