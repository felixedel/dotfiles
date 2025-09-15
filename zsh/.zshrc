# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# NOTE (felix): Using iTerm2 "Tango Dark" theme looks best
ZSH_THEME="felixedel"

plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  dotenv
)

# Activate oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Source custom dotfiles scripts
source ${HOME}/.dotfiles/zsh/.exports
# For a full list of active aliases, run `alias`.
source ${HOME}/.dotfiles/zsh/.aliases
source ${HOME}/.dotfiles/zsh/.functions

local_exports=${HOME}/.exports_local
if [ -f ${local_exports} ]; then
    source ${local_exports}
fi

# Increase number of open file descriptors
ulimit -n 2048

# Enable direnv
eval "$(direnv hook zsh)"

# Enable atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# COMPLETION SETTINGS
# Add custom completion scripts to fpath
export fpath=(~/.dotfiles/zsh/completion ${fpath})
# Initialize zsh completion system
compinit
