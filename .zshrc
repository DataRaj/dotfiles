# --- GVM (Go Version Manager) Setup ---
#
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# --- Oh My Zsh Setup ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
  git
  dnf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- Fastfetch ---
if command -v fastfetch &> /dev/null; then
  fastfetch -c $HOME/.config/fastfetch/config.jsonc
fi

# --- FZF Key Bindings ---
source <(fzf --zsh)

# --- History Options ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# --- Wayland Display Detection (Fix for tmux & nested shells) ---
if [[ -z "$WAYLAND_DISPLAY" || ! -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY" ]]; then
    _rdir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    for _sock in "$_rdir"/wayland-[0-9]*(N); do
        if [[ -S "$_sock" ]]; then
            export WAYLAND_DISPLAY="${_sock:t}"
            [[ ! -e "$_rdir/wayland-0" ]] && ln -sf "$_sock" "$_rdir/wayland-0" 2>/dev/null
            break
        fi
    done
    unset _rdir _sock
fi

# --- Aliases ---
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias vim='nvim'
alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
cpath() {
    if [[ -z "$WAYLAND_DISPLAY" || ! -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$WAYLAND_DISPLAY" ]]; then
        local _r="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
        for _s in "$_r"/wayland-[0-9]*(N); do
            if [[ -S "$_s" ]]; then
                export WAYLAND_DISPLAY="${_s:t}"
                [[ ! -e "$_r/wayland-0" ]] && ln -sf "$_s" "$_r/wayland-0" 2>/dev/null
                break
            fi
        done
    fi
    pwd | wl-copy "$@"
}
alias twmux='tmux-work'

# --- Waydroid Shortcuts ---
alias waystart="waydroid session start"
alias waystop="waydroid session stop"
alias waygui="waydroid show-full-ui"
alias wlc="wl-copy"

# --- Android SDK & Environment Variables ---
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export SNACKS_TERMINAL=foot
export MOZ_ENABLE_WAYLAND=1

# ⚠️ PLACE YOUR ROTATED API KEY HERE (DO NOT LOG PUBLICLY)
export GEMINI_API_KEY="YOUR_NEW_ROTATED_KEY_HERE"

# --- Rust ---
export PATH="$HOME/.cargo/bin:$PATH"

# --- Node: fnm ---
eval "$(fnm env)"

# --- PNPM ---
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Encore ---
export ENCORE_INSTALL="$HOME/.encore"
export PATH="$ENCORE_INSTALL/bin:$PATH"

# --- Custom/External Shell Loaders ---
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X"
. "$HOME/.local/share/../bin/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# =======================================================
# --- Custom Git Automation Functions ---
# =======================================================

# 1. Commit and Branch Auto-deploy
fds() {
  local target_branch=""
  local input_message=""

  if [ -n "$2" ]; then
    target_branch="$1"
    input_message="$2"
  else
    input_message="$1"
  fi

  if [ -n "$target_branch" ]; then
    if git show-ref --verify --quiet "refs/heads/$target_branch"; then
      echo "🔄 Switching to existing branch: $target_branch"
      git checkout "$target_branch"
    else
      echo "✨ Branch '$target_branch' does not exist. Creating and switching..."
      git checkout -b "$target_branch"
    fi
  fi

  git add .
  local changes
  changes=$(git status --short | awk '{print $1}' | sort | uniq -c | awk '{print $2": "$1}')
  
  local commit_message="Updates:"
  while read -r change; do
    [ -n "$change" ] && commit_message="$commit_message $change"
  done <<< "$changes"

  [ -n "$input_message" ] && commit_message="$commit_message - $input_message"

  git commit -m "$commit_message"
  
  local current_branch
  current_branch=$(git branch --show-current)

  echo "🚀 Pushing changes to origin/$current_branch..."
  git push -u origin "$current_branch"
}

# 2. Smart Stash Management
unalias gss 2>/dev/null # 💡 Prevents parse error by clearing prior conflicting system aliases
gss() {
  if [ "$1" = "-a" ]; then
    local search_string="$2"
    
    if [ -n "$search_string" ]; then
      echo "🔍 Searching for a stash containing: '$search_string'..."
      local stash_index
      stash_index=$(git stash list | grep "$search_string" | head -n 1 | cut -d':' -f1)
      
      if [ -n "$stash_index" ]; then
        echo "📥 Found match! Applying $stash_index..."
        git stash apply "$stash_index"
      else
        echo "❌ Error: No stash found matching '$search_string'"
        return 1
      fi
    else
      echo "📥 No name provided. Applying the latest stash..."
      git stash apply
    fi
  else
    local stash_name="$1"
    if [ -n "$stash_name" ]; then
      echo "📦 Stashing everything (including untracked files) as: '$stash_name'..."
      git stash push -u -m "$stash_name"
    else
      echo "❌ Error: Please provide a name to save a stash (e.g., gss 'my-backup'), or use 'gss -a' to apply."
      return 1
    fi
  fi
}


# Added by Antigravity CLI installer
export PATH="/home/dataraj/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Cancel current command line and start fresh prompt on Ctrl+X
ctrl_x_cancel() {
  BUFFER=""
  zle accept-line
}
zle -N ctrl_x_cancel
bindkey '^X' ctrl_x_cancel

alias config='/usr/bin/git --git-dir=/home/dataraj/.cfg/ --work-tree=/home/dataraj'
alias ts='~/.tmux/plugins/tmux-resurrect/scripts/save.sh && cp ~/.tmux/resurrect/last ~/.tmux/resurrect/$(tmux display-message -p "#S") && echo "Profile updated!"'
