# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.

. "$HOME/.local/share/../bin/env"
source "/home/dataraj/.rover/env"


# Added by Antigravity CLI installer
export PATH="/home/dataraj/.local/bin:$PATH"
