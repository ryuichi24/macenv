<h1 align="center">macenv</h1>

## Manual Setup Part

1. Switch Default Shell to Bash
   a. `chsh -s /bin/bash`
   > [!NOTE]
   > You need to make sure the shell is listed in `/etc/shells`
   > since MacOS will allow you to change the shell only if it is listed in `/etc/shells`
2. Install HomeBrew
   a. Install XCode Command Line Tools
3. Git Clone macenv repository
4. Install all tools
   a. `./script/init.sh`
5. Start Karabiner-Elements
   a. Add background processes and give permissions
6. Start Kanata
   a. `initkt`
7. Configure Icon font of iterm2
   a. Cmd + , -> Profile -> Text -> Use a different font for non-ASCII text -> Select "Hack Nerd Font Mono"
8. Start Brave Browser
   a. Install Vimum
   b. Install New Tab Redirect
   c. Set Brave Browser as a default browser on Mac
9. Setup Git Auth
   a. `gh auth login`
   b. git config - `       git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"`

## Dev Setup Part

1. Install Nodejs
   a. `nvm install node`
2. Install Tmux plugins
   a. `prefix + I` within a tmux session
3. Install LSP in neovim
   a. Open mason by `Leader om`
   b. installl LSP servers
