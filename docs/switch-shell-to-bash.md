# How to Switch Shell to Bash

## Install Bash

```bash
brew install bash
```

## Add Bash Bin to /etc/shells

```bash
echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells
```

> [!NOTE]
> `homebrew` creates a symlink to each installed CLI tools in `/opt/homebrew/bin`
> `brew --prefix` returns the path to the folder of the symlinks

## Switch Default Shell to Bash

This command will change the default shell to bash

```bash
chsh -s $(brew --prefix)/bin/bash
```
