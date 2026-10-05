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

alias xx='NVIM_APPNAME=nvimx /opt/homebrew/bin/nvim'

# tmux
TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"
alias tmux='tmux -f $TMUX_CONFIG'
alias tmn='tmux new -s' # create a new session with a given name
alias tmw='tmux new-window -n' # create a new window with a given name
alias tmd='tmux detach' # detach from the current session
alias tma='tmux attach -t' # attach to a session with a given name
alias tmk='tmux kill-session -t' # kill all sessions
alias tmks='tmux kill-server' # kill all sessions
alias tml='tmux ls' # create a new session with a given name
alias tmr='tmux source-file $TMUX_CONFIG' # reload config

# pnpm
alias pn='pnpm'

# kanata
alias initkt='sudo kanata -c $HOME/.config/kanata/config.kbd -d'

# util
# general
alias ch="cat ~/.bashrc"
alias appd="cd $HOME/Library/Application\ Support/"

# quick edit
DEV="$HOME/dev"
PROJECTS="$DEV/personal/projects"
MAC_ENV="$PROJECTS/macenv"

alias ee='cd $MAC_ENV && vi .'
alias nn='cd $MAC_ENV/files/.config/nvim && vi .'
alias pp='cd $PROJECTS && vi .'
alias mm='cd $PROJECTS/my-knowledge-base && vi .'
alias dd='cd "$PROJECTS/my-knowledge-base" && file="./daily/$(date +%Y-%m-%d).md" && [ ! -f "$file" ] && touch "$file"; vi "$file"'

# quick open
alias des='cd $HOME/Desktop && y'
alias dev='cd $DEV && y'
alias pro='cd $PROJECTS && y'
alias tmp='cd $PROJECTS/tmp && y'


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

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# util

# Manage macOS system sleep settings.
# Usage:
#   sleep off     Disable automatic sleep
#   sleep on      Enable automatic sleep after 10 minutes
#   sleep status  Show the current sleep setting
sleep() {
  case "$1" in
    off)
      sudo pmset -a sleep 0
      echo "Mac sleep disabled"
      ;;
    on)
      sudo pmset -a sleep 10
      echo "Mac sleep enabled (10 min)"
      ;;
    status)
      pmset -g | grep -E '^[[:space:]]*sleep '
      ;;
    *)
      echo "Usage: sleepmode {on|off|status}"
      ;;
  esac
}



# Manage macOS caffeinate mode.
# Usage:
#   caffeinemode on      Prevent idle/system/display/disk sleep
#   caffeinemode off     Stop caffeinate and restore normal sleep behavior
#   caffeinemode status  Show whether caffeinate is running
caff() {
  case "$1" in
    on)
      if pgrep -x caffeinate >/dev/null; then
        echo "Caffeinate is already enabled"
      else
        caffeinate -dims >/dev/null 2>&1 &
        disown
        echo "Caffeinate enabled"
      fi
      ;;
    off)
      if pkill -x caffeinate; then
        echo "Caffeinate disabled"
      else
        echo "Caffeinate is not running"
      fi
      ;;
    status)
      if pgrep -x caffeinate >/dev/null; then
        echo "Caffeinate: ON"
        pmset -g assertions | grep -A 10 "Assertion status system-wide"
      else
        echo "Caffeinate: OFF"
      fi
      ;;
    *)
      echo "Usage: caffeinemode {on|off|status}"
      ;;
  esac
}

# util end

