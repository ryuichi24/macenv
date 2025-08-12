#!/bin/bash

shopt -s nullglob dotglob # Enable nullglob and dotglob to include hidden files

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

# HOME_DIR="$HOME"
HOME_DIR="./test-home-dir"
CONFIG_DIR="$HOME_DIR/.config"
SOURCE_FILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/files"
SOURCE_CONFIG_DIR="$SOURCE_FILES_DIR/.config"
SOURCE_DOTFILES_DIR="$SOURCE_FILES_DIR/dotfiles"

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


# install apps
#
