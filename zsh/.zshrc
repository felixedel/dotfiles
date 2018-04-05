# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"
#ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Add MacPorts to path
export PATH=/opt/local/bin:~/bin:$PATH
export PATH=${HOME}/.npm-packages/bin:${PATH}
export LC_ALL=en_GB.utf-8
export LANG=en_GB.utf-8

# Activate the fuck
eval $(thefuck --alias f)

# Environment
EDITOR=vim

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ll='ls -laF'
alias ptg='git push origin HEAD:refs/for/master'
alias git='LANG=en_GB git'
alias weekly="git log --oneline --author 'Felix' --since=1.weeks --no-merges"
alias sourcetree='open -a SourceTree ./'

# Custom functions
prettyjson_s() {
    echo "$1" | python -m json.tool
}

prettyjson_f() {
    python -m json.tool "$1"
}

prettyjson_w() {
    curl "$1" | python -m json.tool
}
