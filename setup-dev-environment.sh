#!/bin/bash

echo "============================================"
echo "Development Environment Setup for Linux"
echo "============================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "ERROR: This script should NOT be run as root!"
    echo "Run without sudo. The script will ask for sudo when needed."
    exit 1
fi

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "ERROR: Cannot detect Linux distribution"
    exit 1
fi

echo "Detected distribution: $DISTRO"
echo ""
echo "This script will help you set up your development environment."
echo "You can choose which components to install."
echo ""

read -p "Update system packages? (Y/N): " UPDATE_SYSTEM
read -p "Install Zsh shell? (Y/N): " INSTALL_ZSH
read -p "Install Oh-My-Zsh? (Y/N): " INSTALL_OHMYZSH
read -p "Install Powerlevel10k theme? (Y/N): " INSTALL_P10K
read -p "Apply dotfiles configuration? (Y/N): " APPLY_DOTFILES
read -p "Install Oh-My-Zsh plugins? (Y/N): " INSTALL_PLUGINS
read -p "Install development tools (git, curl, wget, build-essential)? (Y/N): " INSTALL_DEVTOOLS
read -p "Install Node.js via NVM? (Y/N): " INSTALL_NODE
read -p "Configure SSH? (Y/N): " SETUP_SSH
read -p "Install 0xProto Nerd Font Mono? (Y/N): " INSTALL_NERDFONT
read -p "Install additional applications (Discord, Steam, PowerToys alternative)? (Y/N): " INSTALL_APPS

echo ""
echo "============================================"
echo "Starting installation..."
echo "============================================"
echo ""

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update system packages
if [[ "$UPDATE_SYSTEM" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 1: Updating system packages..."
    case $DISTRO in
        ubuntu|debian|pop)
            sudo apt update && sudo apt upgrade -y
            ;;
        fedora)
            sudo dnf update -y
            ;;
        arch|manjaro)
            sudo pacman -Syu --noconfirm
            ;;
        *)
            echo "Unsupported distribution for automatic updates"
            ;;
    esac
    echo "System packages updated successfully!"
else
    echo "Skipping system update..."
fi

# Install development tools
if [[ "$INSTALL_DEVTOOLS" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 2: Installing development tools..."
    case $DISTRO in
        ubuntu|debian|pop)
            sudo apt install -y git curl wget build-essential
            ;;
        fedora)
            sudo dnf install -y git curl wget gcc gcc-c++ make
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm git curl wget base-devel
            ;;
        *)
            echo "Please install git, curl, wget manually for your distribution"
            ;;
    esac
    echo "Development tools installed successfully!"
else
    echo "Skipping development tools installation..."
fi

# Install Zsh
if [[ "$INSTALL_ZSH" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 3: Installing Zsh shell..."
    case $DISTRO in
        ubuntu|debian|pop)
            sudo apt install -y zsh
            ;;
        fedora)
            sudo dnf install -y zsh
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm zsh
            ;;
        *)
            echo "Please install zsh manually for your distribution"
            ;;
    esac
    echo "Zsh installed successfully!"
    
    echo ""
    read -p "Set Zsh as default shell? (Y/N): " SET_DEFAULT_ZSH
    if [[ "$SET_DEFAULT_ZSH" =~ ^[Yy]$ ]]; then
        chsh -s $(which zsh)
        echo "Zsh set as default shell!"
    fi
else
    echo "Skipping Zsh installation..."
fi

# Install Oh-My-Zsh
if [[ "$INSTALL_OHMYZSH" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 4: Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh-My-Zsh installed successfully!"
else
    echo "Skipping Oh-My-Zsh installation..."
fi

# Install Powerlevel10k
if [[ "$INSTALL_P10K" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 5: Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
    
    echo ""
    echo "Step 6: Configuring Powerlevel10k theme..."
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ${HOME}/.zshrc
    echo "Powerlevel10k installed and configured!"
    echo ""
    echo "NOTE: Powerlevel10k configuration wizard will run automatically on first Zsh launch."
    echo "      The wizard will guide you through customizing your prompt appearance."
else
    echo "Skipping Powerlevel10k installation..."
fi

# Apply dotfiles
if [[ "$APPLY_DOTFILES" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 7: Applying dotfiles configuration..."
    
    read -p "Do you want to override Powerlevel10k config with dotfiles .p10k.zsh? (Y/N): " OVERRIDE_P10K
    
    if [ -f "$DOTFILES_DIR/.zshrc" ]; then
        cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
        echo ".zshrc applied successfully!"
    fi
    
    if [ -f "$DOTFILES_DIR/.bashrc" ]; then
        cp "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
        echo ".bashrc applied successfully!"
    fi
    
    if [ -f "$DOTFILES_DIR/.bash_profile" ]; then
        cp "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
        echo ".bash_profile applied successfully!"
    fi
    
    if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
        cp "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
        echo ".gitconfig applied successfully!"
    fi
    
    if [ -f "$DOTFILES_DIR/.gitignore" ]; then
        cp "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
        echo ".gitignore applied successfully!"
    fi
    
    if [[ "$OVERRIDE_P10K" =~ ^[Yy]$ ]]; then
        if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
            cp "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
            echo ".p10k.zsh applied successfully!"
            echo "NOTE: This will skip the Powerlevel10k configuration wizard on first launch."
        fi
    else
        echo "Skipping .p10k.zsh - Configuration wizard will run on first Zsh launch."
    fi
    
    if [ -d "$DOTFILES_DIR/.config" ]; then
        cp -r "$DOTFILES_DIR/.config/." "$HOME/.config/"
        echo ".config directory applied successfully!"
    fi
    
    echo ""
    echo "Step 8: Copying aliases.zsh to Oh-My-Zsh custom folder..."
    if [ -f "$DOTFILES_DIR/.oh-my-zsh/custom/aliases.zsh" ]; then
        mkdir -p "$HOME/.oh-my-zsh/custom"
        cp "$DOTFILES_DIR/.oh-my-zsh/custom/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
        echo "aliases.zsh copied successfully!"
    fi
else
    echo "Skipping dotfiles application..."
fi

# Install Oh-My-Zsh plugins
if [[ "$INSTALL_PLUGINS" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 9: Installing Oh-My-Zsh custom plugins..."
    if [ -f "$DOTFILES_DIR/oh-my-zsh-plugins.txt" ]; then
        while IFS= read -r plugin; do
            echo "Installing plugin: $plugin"
            git clone "https://github.com/zsh-users/$plugin" "${HOME}/.oh-my-zsh/custom/plugins/$plugin"
        done < "$DOTFILES_DIR/oh-my-zsh-plugins.txt"
        echo "Plugins installed successfully!"
    else
        echo "WARNING: oh-my-zsh-plugins.txt not found, skipping..."
    fi
else
    echo "Skipping Oh-My-Zsh plugins installation..."
fi

# Install Node.js via NVM
if [[ "$INSTALL_NODE" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 10: Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    echo ""
    echo "Installing latest LTS version of Node.js..."
    nvm install --lts
    nvm use --lts
    echo "Node.js installed successfully!"
else
    echo "Skipping Node.js installation..."
fi

# Configure SSH
if [[ "$SETUP_SSH" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 11: SSH Key Configuration..."
    read -p "Do you want to create an SSH RSA key? (Y/N): " CREATE_SSH_KEY
    if [[ "$CREATE_SSH_KEY" =~ ^[Yy]$ ]]; then
        echo ""
        echo "Creating SSH RSA key..."
        read -p "Enter your email for SSH key: " SSH_EMAIL
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t rsa -b 4096 -C "$SSH_EMAIL" -f "$HOME/.ssh/id_rsa"
        echo "SSH key created successfully!"
        echo ""
        echo "Your public key:"
        cat "$HOME/.ssh/id_rsa.pub"
        echo ""
    else
        echo "Skipping SSH key creation..."
    fi
    
    echo ""
    echo "Copying SSH config from dotfiles..."
    if [ -f "$DOTFILES_DIR/.ssh/config" ]; then
        mkdir -p "$HOME/.ssh"
        cp "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        echo "SSH config copied successfully!"
    else
        echo "WARNING: .ssh/config not found in dotfiles, skipping..."
    fi
else
    echo "Skipping SSH configuration..."
fi

# Install Nerd Font
if [[ "$INSTALL_NERDFONT" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 12: Installing 0xProto Nerd Font Mono..."
    echo "Fetching latest Nerd Fonts release..."
    
    FONT_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*0xProto.zip" | cut -d '"' -f 4)
    
    mkdir -p /tmp/nerd-fonts
    curl -L "$FONT_URL" -o /tmp/nerd-fonts/0xProto.zip
    
    echo "Extracting font files..."
    unzip -o /tmp/nerd-fonts/0xProto.zip -d /tmp/nerd-fonts/0xProto
    
    echo "Installing fonts..."
    mkdir -p "$HOME/.local/share/fonts"
    cp /tmp/nerd-fonts/0xProto/*.ttf "$HOME/.local/share/fonts/"
    
    echo "Updating font cache..."
    fc-cache -fv
    
    echo "Cleaning up..."
    rm -rf /tmp/nerd-fonts
    
    echo "0xProto Nerd Font Mono installed successfully!"
else
    echo "Skipping Nerd Font installation..."
fi

# Install applications
if [[ "$INSTALL_APPS" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Step 13: Installing additional applications..."
    
    case $DISTRO in
        ubuntu|debian|pop)
            echo ""
            echo "Installing Discord..."
            wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
            sudo apt install -y /tmp/discord.deb
            rm /tmp/discord.deb
            
            echo ""
            echo "Installing Steam..."
            sudo apt install -y steam-installer
            
            echo ""
            echo "Installing GNOME Tweaks (PowerToys alternative)..."
            sudo apt install -y gnome-tweaks gnome-shell-extensions
            ;;
        fedora)
            echo ""
            echo "Installing Discord..."
            wget -O /tmp/discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
            sudo tar -xzf /tmp/discord.tar.gz -C /opt
            sudo ln -sf /opt/Discord/Discord /usr/bin/Discord
            rm /tmp/discord.tar.gz
            
            echo ""
            echo "Installing Steam..."
            sudo dnf install -y steam
            
            echo ""
            echo "Installing GNOME Tweaks (PowerToys alternative)..."
            sudo dnf install -y gnome-tweaks gnome-extensions-app
            ;;
        arch|manjaro)
            echo ""
            echo "Installing Discord..."
            sudo pacman -S --noconfirm discord
            
            echo ""
            echo "Installing Steam..."
            sudo pacman -S --noconfirm steam
            
            echo ""
            echo "Installing GNOME Tweaks (PowerToys alternative)..."
            sudo pacman -S --noconfirm gnome-tweaks
            ;;
        *)
            echo "Please install applications manually for your distribution"
            ;;
    esac
    
    echo "Applications installed successfully!"
else
    echo "Skipping applications installation..."
fi

echo ""
echo "============================================"
echo "Installation Complete!"
echo "============================================"
echo ""
echo "Installed components summary:"
[[ "$INSTALL_ZSH" =~ ^[Yy]$ ]] && echo "- Zsh shell"
[[ "$INSTALL_OHMYZSH" =~ ^[Yy]$ ]] && echo "- Oh-My-Zsh"
[[ "$INSTALL_P10K" =~ ^[Yy]$ ]] && echo "- Powerlevel10k theme"
[[ "$INSTALL_DEVTOOLS" =~ ^[Yy]$ ]] && echo "- Development tools (git, curl, wget, build-essential)"
[[ "$INSTALL_NODE" =~ ^[Yy]$ ]] && echo "- Node.js via NVM"
[[ "$INSTALL_NERDFONT" =~ ^[Yy]$ ]] && echo "- 0xProto Nerd Font Mono"
[[ "$INSTALL_APPS" =~ ^[Yy]$ ]] && echo "- Discord" && echo "- Steam" && echo "- GNOME Tweaks"
echo ""
echo "IMPORTANT NEXT STEPS:"
echo "1. Close this terminal and open a new one"
if [[ "$INSTALL_P10K" =~ ^[Yy]$ ]]; then
    if [[ "$OVERRIDE_P10K" =~ ^[Yy]$ ]]; then
        echo "2. Zsh will start with your custom Powerlevel10k configuration"
    else
        echo "2. Zsh will start and Powerlevel10k configuration wizard will run"
        echo "3. Follow the Powerlevel10k setup wizard to customize your prompt"
    fi
fi
echo ""
if [[ "$INSTALL_NERDFONT" =~ ^[Yy]$ ]]; then
    echo "4. 0xProto Nerd Font Mono is installed!"
    echo "   Configure your terminal to use it in terminal preferences."
else
    echo "4. Install a Nerd Font for best Powerlevel10k experience:"
    echo "   https://github.com/ryanoasis/nerd-fonts/releases"
fi
echo ""
echo "To verify installations:"
echo "- Git: git --version"
echo "- Zsh: zsh --version"
echo "- Oh-My-Zsh: ls ~/.oh-my-zsh"
echo "- Node.js: node --version"
echo "- NPM: npm --version"
echo ""
echo "============================================"
