# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

plugins=(
  zsh-syntax-highlighting
  dotenv
)

# Activate oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Source custom dotfiles scripts
source ${HOME}/.dotfiles/zsh/.exports
# For a full list of active aliases, run `alias`.
source ${HOME}/.dotfiles/zsh/.aliases
source ${HOME}/.dotfiles/zsh/.functions

# COMPLETION SETTINGS
# Add custom completion scripts to fpath
export fpath=(~/.dotfiles/zsh/completion ${fpath})
# Initialize zsh completion system
compinit
