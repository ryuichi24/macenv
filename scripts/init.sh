#!/bin/bash

shopt -s nullglob dotglob # Enable nullglob and dotglob to include hidden files

# Git clone submodule if not already done :https://zenn.dev/okina/articles/7cd4f80b435cc1
if [ ! -d "./files/.config/nvim/.git" ]; then
    echo "Cloning submodules..."
    git submodule update --init --recursive
fi

# Define a function to create a symlink to a directory
symlink_dir() {
    local src_dir="$1"      # Original directory to link to
    local target_dir="$2"   # Symlink to create

    # Check if source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Error: Source directory '$src_dir' does not exist."
        return 1
    fi

    # If target exists and is a symlink or directory, remove it
    if [ -L "$target_dir" ] || [ -d "$target_dir" ]; then
        echo "Removing existing target '$target_dir'"
        rm -rf "$target_dir"
    fi

    # Create the symlink
    ln -s "$src_dir" "$target_dir"
    echo "Symlink created: $target_dir → $src_dir"
}

sysmlink_file() {
    local src_file="$1"      # Original file to link to
    local target_file="$2"   # Symlink to create

    # Check if source file exists
    if [ ! -f "$src_file" ]; then
        echo "Error: Source file '$src_file' does not exist."
        return 1
    fi

    # If target exists and is a symlink or file, remove it
    if [ -L "$target_file" ] || [ -f "$target_file" ]; then
        echo "Removing existing target '$target_file'"
        rm -f "$target_file"
    fi

    # Create the symlink
    ln -s "$src_file" "$target_file"
    echo "Symlink created: $target_file → $src_file"
}

echo "Initialize the mac environment"
FILENAME="${BASH_SOURCE[0]}"
DIRNAME="$(dirname "$FILENAME")"
WORKING_DIR="$(cd "$DIRNAME/.." && pwd)"
HOME_DIR="$HOME"
# HOME_DIR="./test-home-dir"
CONFIG_DIR="$HOME_DIR/.config"
SOURCE_FILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/files"
SOURCE_CONFIG_DIR="$SOURCE_FILES_DIR/.config"
SOURCE_DOTFILES_DIR="$SOURCE_FILES_DIR/dotfiles"


# =============================================
# File System
# =============================================
dev_folders=("$HOME_DIR/dev/personal/tmp" "$HOME_DIR/dev/work/tmp")
log_info "Creating development directories..."
for folder in "${dev_folders[@]}"; do
    if [ ! -d "$folder" ]; then
        mkdir -p "$folder"
        log_success "Created directory: $folder"
    else
        log_warn "Directory already exists: $folder"
    fi
done
log_success "File system setup completed."

# =============================================
# Symlink Initialization
# =============================================

# Create symlinks for each file in SOURCE_DOTFILES_DIR
for dotfile in "$SOURCE_DOTFILES_DIR"/.*; do
    # Skip current and parent directory entries
    if [ "$(basename "$dotfile")" == "." ] || [ "$(basename "$dotfile")" == ".." ]; then
        continue 
    fi

    # Skip directories
    if [ -d "$dotfile" ]; then
        continue  
    fi

    # check if the same symlink already exists
    target_file="$HOME_DIR/$(basename "$dotfile")"
    if [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$dotfile" ]; then
        echo "Symlink already exists for $dotfile"
        continue
    fi

    sysmlink_file "$dotfile" "$target_file"
    echo "Created symlink for $dotfile"
done


# Create symlinks for directories in .config
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating config directory at $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi


# Create symlinks for each config dir in SOURCE_CONFIG_DIR
for config in "$SOURCE_CONFIG_DIR"/*; do
    # Skip current and parent directory entries
    if [ "$(basename "$config")" == "." ] || [ "$(basename "$config")" == ".." ]; then
        continue 
    fi

    # Skip files
    if [ -f "$config" ]; then
        continue  
    fi

    # check if the same symlink already exists
    target_config="$CONFIG_DIR/$(basename "$config")"
    if [ -L "$target_config" ] && [ "$(readlink "$target_config")" == "$config" ]; then
        echo "Symlink already exists for $config"
        continue
    fi

    symlink_dir "$config" "$target_config"
    echo "Created symlink for $config"
done

shopt -u nullglob dotglob # Enable nullglob and dotglob to include hidden files

# =============================================
# Homebrew installation
# =============================================


# =============================================
# CLI and App installation
# =============================================

# import apps
source $WORKING_DIR/modules/apps.sh


echo "Working Dir: $WORKING_DIR"
echo "Dirname: $DIRNAME" 
echo "Filename: $FILENAME" 

for item in "${BREW_TAPS[@]}"; do
    if brew tap | grep -qx "$item"; then
        echo "$item is already registered"
        continue
    fi
    # if ! brew tap "$item"; then
    #     echo "Failed to register a tap: $item"
    #     return 1
    # fi
done

for item in "${BREW_CLIS[@]}"; do
    echo "Installing CLI tool: $item"
    if brew list --formula | grep -qx "$item"; then
        echo "$item is already installed."
        continue
    fi
    #
    # if ! brew install "$item"; then
    #     echo "Failed to install CLI tool: $item"
    #     return 1
    # fi
    echo "Successfully installed CLI tool: $item"
done

for item in "${CASK_APPS[@]}"; do
    echo "Installing GUI app: $item"
    if brew list --cask | grep -qx "$item"; then
        echo "$item is already installed."
        continue
    fi

    # if ! brew install --cask "$item"; then
    #     echo "Failed to install GUI app: $item"
    #     return 1
    # fi
    echo "Successfully installed GUI app: $item"
done

for mas_id in ${MAS_APPS[@]}; do
    mas_name=$(mas search $mas_id | awk '{ print $2 }')
    echo "Installing: $mas_name ($mas_id)"

    # temp
    continue

    output=$(mas install "$mas_id" 2>&1)
    status=$?

    # "-ne" means "not equal" for "numbers"
    if [[ $status -ne 0 ]]; then
        echo "Failed to install $mas_name ($mas_id). Are you logged into the Mac App Store?"
        return 1
    fi

    echo "$output" | grep -q "already installed"
    already_installed=$?
    if [[ $already_installed -eq 0 ]]; then
        echo "$mas_name is already installed."
        continue
    fi

    echo "Successfully installed $mas_name"
done

# Install tmux plugin manager
if [ -d "$HOME_DIR/.tmux/plugins/tpm" ]; then
    echo "tmux plugin manager already installed."
else
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
