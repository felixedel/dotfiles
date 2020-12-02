# dotfiles

## ZSH

Clone necessary zsh plugin repositories

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

## iTerm2 settings

### Profile settings
- **Color Theme:** Tango Dark
- **Font:** DejaVu Sans Mono Nerd Font Complete 12pt (https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf)
- **Terminal type:** xterm-256color

To allow jumping words via arrow keys, change the following key mappings in `profile -> keys`:
- `Option+<-`: `Send Escape Sequence` with value `b`
- `Option+->`: `Send Escape Sequence` with value `f`

### tmux integration
- **Open tmux windows as native windows**

### Vim setup

Clone vundle to manage Vim plugins
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Create the vim swapfiles directory:
```bash
$ mkdir ~/.vim/swapfiles
```

On first start of vim, run `:PluginInstall` to install necessary plugins.

## VS Code
1. Install [FiraCode](https://github.com/tonsky/FiraCode) to enable font ligatures.
2. Link the `settings.json` file from this repository to the original VS Code settings location:
```bash
ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

## Links
**iTerm2 color schemes:** https://github.com/mbadolato/iTerm2-Color-Schemes
**Nerd font for agnoster theme with venv icon:** https://github.com/ryanoasis/nerd-fonts
**zsh themes:** https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
**zsh agnoster:** https://github.com/agnoster/agnoster-zsh-theme
**zsh powerlevel9k:** https://github.com/bhilburn/powerlevel9k

### Misc
https://opensource.com/article/18/9/tips-productivity-zsh
