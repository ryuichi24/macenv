# bash
alias ls='ls -larth --color=auto'
alias ..="cd .. && ls"
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | pbcopy && echo "UUID copied to clipboard"'

# neovim
alias vi='NVIM_APPNAME=nvim/src nvim' # https://wiki.archlinux.org/title/Neovim
alias vim='NVIM_APPNAME=nvim/src nvim'

# pnpm
alias pn='pnpm'

# kanata
alias initkt='sudo kanata -c $HOME/.config/kanata/config.kbd -d'

# util
