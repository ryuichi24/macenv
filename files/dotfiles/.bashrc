# bash
alias ls='ls -larth --color=auto'
alias ..="cd .. && ls"
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | pbcopy && echo "UUID copied to clipboard"'

# neovim
alias vi='NVIM_APPNAME=nvim/src nvim' # https://wiki.archlinux.org/title/Neovim
alias vim='NVIM_APPNAME=nvim/src nvim'

# tmux
alias tmux='tmux -f $HOME/.config/tmux/tmux.conf' # use custom config file ans start tmux
alias tmn='tmux new -s' # create a new session with a given name
alias tmd='tmux detach' # detach from the current session
alias tma='tmux attach -t' # attach to a session with a given name
alias tmk='tmux kill-session -t' # kill all sessions
alias tmks='tmux kill-server' # kill all sessions
alias tml='tmux ls' # create a new session with a given name

# pnpm
alias pn='pnpm'

# kanata
alias initkt='sudo kanata -c $HOME/.config/kanata/config.kbd -d'

# util
