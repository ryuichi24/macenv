# https://discussions.apple.com/thread/255287296?utm_source=chatgpt.com&sortBy=rank
# https://www.theverge.com/2019/6/4/18651872/apple-macos-catalina-zsh-bash-shell-replacement-features
# https://discussions.apple.com/thread/250729585?sortBy=rank
export BASH_SILENCE_DEPRECATION_WARNING=1

# ~/.bash_profile: executed by bash(1) for non-login shells.
if [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# go
export PATH="$PATH:$(go env GOPATH)/bin"

# iterm2
DISABLE_AUTO_TITLE="true"

precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}
