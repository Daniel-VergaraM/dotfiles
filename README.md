# Dotfiles Deployment Guide

This directory contains configuration files for easier deployment across different operating systems.

## Files included:
- `.bashrc` - Bash shell configuration
- `.bash_profile` - Bash profile
- `.gitconfig` - Git configuration
- `.gitignore` - Global gitignore patterns
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.ssh/config` - SSH configuration

## Deployment:

### Linux/macOS:
```bash
cp dotfiles/.bashrc ~/
cp dotfiles/.bash_profile ~/
cp dotfiles/.gitconfig ~/
cp dotfiles/.gitignore ~/
cp dotfiles/.p10k.zsh ~/
cp dotfiles/.ssh/config ~/.ssh/
```

### Windows (Git Bash/WSL):
```bash
cp dotfiles/.bashrc ~/
cp dotfiles/.bash_profile ~/
cp dotfiles/.gitconfig ~/
cp dotfiles/.gitignore ~/
cp dotfiles/.p10k.zsh ~/
cp dotfiles/.ssh/config ~/.ssh/
```

## Note:
Before copying `.gitconfig`, update the user name and email to match your credentials.
# Dotfiles
