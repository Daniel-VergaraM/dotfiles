#!/bin/bash

echo "========================================"
echo "Dotfiles Configuration Saver (Linux)"
echo "========================================"
echo

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "This script will copy your current configuration files to the dotfiles directory."
echo "Dotfiles directory: $DOTFILES_DIR"
echo

read -p "Do you want to continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
fi

echo
echo "Copying configuration files..."
echo

copy_file() {
    local src="$1"
    local dest="$2"
    local name="$3"
    
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "[OK] Copied $name"
    else
        echo "[SKIP] $name not found"
    fi
}

copy_dir() {
    local src="$1"
    local dest="$2"
    local name="$3"
    
    if [ -d "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp -r "$src" "$dest"
        echo "[OK] Copied $name"
    else
        echo "[SKIP] $name not found"
    fi
}

copy_file "$HOME_DIR/.bashrc" "$DOTFILES_DIR/.bashrc" ".bashrc"
copy_file "$HOME_DIR/.bash_profile" "$DOTFILES_DIR/.bash_profile" ".bash_profile"
copy_file "$HOME_DIR/.zshrc" "$DOTFILES_DIR/.zshrc" ".zshrc"
copy_file "$HOME_DIR/.gitconfig" "$DOTFILES_DIR/.gitconfig" ".gitconfig"
copy_file "$HOME_DIR/.gitignore" "$DOTFILES_DIR/.gitignore" ".gitignore"
copy_file "$HOME_DIR/.p10k.zsh" "$DOTFILES_DIR/.p10k.zsh" ".p10k.zsh"

if [ -f "$HOME_DIR/.ssh/config" ]; then
    mkdir -p "$DOTFILES_DIR/.ssh"
    cp "$HOME_DIR/.ssh/config" "$DOTFILES_DIR/.ssh/config"
    echo "[OK] Copied .ssh/config"
else
    echo "[SKIP] .ssh/config not found"
fi

if [ -d "$HOME_DIR/.oh-my-zsh/custom" ]; then
    mkdir -p "$DOTFILES_DIR/.oh-my-zsh/custom"
    # Copy all .zsh files from custom directory
    find "$HOME_DIR/.oh-my-zsh/custom" -maxdepth 1 -name "*.zsh" -exec cp {} "$DOTFILES_DIR/.oh-my-zsh/custom/" \; 2>/dev/null
    echo "[OK] Copied .oh-my-zsh/custom/*.zsh files"
else
    echo "[SKIP] .oh-my-zsh/custom not found"
fi

copy_file "$HOME_DIR/.config/fastfetch/config.jsonc" "$DOTFILES_DIR/.config/fastfetch/config.jsonc" ".config/fastfetch/config.jsonc"
copy_file "$HOME_DIR/.config/gh/config.yml" "$DOTFILES_DIR/.config/gh/config.yml" ".config/gh/config.yml"

# Skipping github-copilot - contains sensitive information
echo "[SKIP] .config/github-copilot (contains sensitive information)"

if [ -d "$HOME_DIR/.config/opencode" ]; then
    mkdir -p "$DOTFILES_DIR/.config/opencode"
    # Copy excluding node_modules and .git
    rsync -av --exclude='node_modules' --exclude='.git' "$HOME_DIR/.config/opencode/" "$DOTFILES_DIR/.config/opencode/" > /dev/null 2>&1
    echo "[OK] Copied .config/opencode"
else
    echo "[SKIP] .config/opencode not found"
fi

if [ -d "$HOME_DIR/.config/nvim" ]; then
    mkdir -p "$DOTFILES_DIR/.config"
    cp -r "$HOME_DIR/.config/nvim" "$DOTFILES_DIR/.config/nvim"
    echo "[OK] Copied .config/nvim"
else
    echo "[SKIP] .config/nvim not found"
fi

echo
echo "========================================"
echo "Configuration save complete!"
echo "========================================"
