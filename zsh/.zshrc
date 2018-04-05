# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

plugins=(
  git
  zsh-syntax-highlighting
)

# Activate oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Source custom .dotfiles
source ${HOME}/.exports
# For a full list of active aliases, run `alias`.
source ${HOME}/.aliases
source ${HOME}/.functions
