# bash
alias ss='source ~/.bash_profile && echo "Reloaded .bash_profile & .bashrc successfully!"'
alias ls='ls -larth --color=auto'
alias ..="cd .. && ls"
alias cc="clear"
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | pbcopy && echo "UUID copied to clipboard"'
alias cpwd='pwd | pbcopy && echo "Current directory path copied to clipboard"'
alias cdc='cd "$(pbpaste)"' # cd into path copied to clipboard

# git

# nvim # https://wiki.archlinux.org/title/neovim
NVIM_DIR="nvim"
alias vi='NVIM_APPNAME=$NVIM_DIR nvim' 
alias vim='NVIM_APPNAME=$NVIM_DIR nvim'
alias nvim='NVIM_APPNAME=$NVIM_DIR nvim'

alias yy='NVIM_APPNAME=nvimy /opt/homebrew/bin/nvim'

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
# general
alias ch="cat ~/.bashrc"
alias appd="cd $HOME/Library/Application\ Support/"

# quick edit
alias ee='cd $HOME/Dev/personal/projects/macenv && vi .'
alias nn='cd $HOME/Dev/personal/projects/macenv/files/.config/nvim && vi .'
alias pp='cd $HOME/Dev/personal/projects && vi .'
alias mm='cd $HOME/Dev/personal/projects/my-knowledge-base && vi .'
alias dd='cd "$HOME/dev/personal/projects/my-knowledge-base" && file="./daily/$(date +%Y-%m-%d).md" && [ ! -f "$file" ] && touch "$file"; vi "$file"'

# quick open
alias des='cd $HOME/Desktop && y'
alias dev='cd $HOME/dev && y'
alias pro='cd $HOME/dev/personal/projects && y'
alias tmp='cd $HOME/dev/personal/tmp && y'


# opencode
export PATH=/Users/ryu/.opencode/bin:$PATH

# yazy
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# uncommited bachrc for private use
if [ -r ~/.pbashrc ]; then
    . ~/.pbashrc
fi


# Process Manager
alias pp="rip -f"


ffn() {
  local target_dir="${1:-.}"
  local replacement="${2:-_}"

  find "$target_dir" -depth -name "* *" | while IFS= read -r path; do
    local new_path="${path// /$replacement}"

    if [[ "$path" != "$new_path" ]]; then
      mv -i -- "$path" "$new_path"
    fi
  done
}
