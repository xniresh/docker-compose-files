#!/bin/bash

# ZSH, Oh My Zsh, and plugins installation script for Ubuntu
# Based on official documentation:
# - https://ohmyz.sh/
# - https://github.com/zsh-users/zsh-autosuggestions
# - https://github.com/zsh-users/zsh-syntax-highlighting
# - https://github.com/carloscuesta/materialshell

# Exit immediately if a command exits with a non-zero status
set -e

# Print commands before executing them
set -x

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Starting ZSH installation process..."

# Check if ZSH is already installed
if command_exists zsh; then
    echo "ZSH is already installed. Checking version..."
    zsh --version
    read -p "Do you want to proceed with reinstallation? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping ZSH installation."
    else
        echo "Reinstalling ZSH..."
        sudo apt update
        sudo apt install -y zsh
    fi
else
    echo "Installing ZSH..."
    sudo apt update
    sudo apt install -y zsh
fi

# Set ZSH as default shell
if [[ $SHELL != *"zsh"* ]]; then
    echo "Setting ZSH as default shell..."
    chsh -s $(which zsh)
    echo "ZSH has been set as your default shell. Changes will take effect after you log out and back in."
else
    echo "ZSH is already your default shell."
fi

# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
    read -p "Do you want to reinstall Oh My Zsh? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing Oh My Zsh installation..."
        rm -rf "$HOME/.oh-my-zsh"
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
else
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin
ZSH_AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
    echo "zsh-autosuggestions plugin is already installed."
    read -p "Do you want to update it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating zsh-autosuggestions..."
        cd "$ZSH_AUTOSUGGESTIONS_DIR" && git pull
    fi
else
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting plugin
ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    echo "zsh-syntax-highlighting plugin is already installed."
    read -p "Do you want to update it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating zsh-syntax-highlighting..."
        cd "$ZSH_SYNTAX_HIGHLIGHTING_DIR" && git pull
    fi
else
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install materialshell theme
MATERIALSHELL_THEME_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/materialshell.zsh-theme"
if [ -f "$MATERIALSHELL_THEME_PATH" ]; then
    echo "materialshell theme is already installed."
    read -p "Do you want to update it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating materialshell theme..."
        curl -fsSL https://raw.githubusercontent.com/carloscuesta/materialshell/master/materialshell.zsh-theme -o "$MATERIALSHELL_THEME_PATH"
        echo "materialshell theme has been updated."
    fi
else
    echo "Installing materialshell theme..."
    # Download the theme file from GitHub repository to Oh My Zsh themes directory
    curl -fsSL https://raw.githubusercontent.com/carloscuesta/materialshell/master/materialshell.zsh-theme -o "$MATERIALSHELL_THEME_PATH"
    if [ $? -eq 0 ]; then
        echo "materialshell theme has been downloaded successfully."
    else
        echo "Failed to download materialshell theme. Please check your internet connection."
        exit 1
    fi
fi

# Update .zshrc file to enable plugins and theme
echo "Updating .zshrc file to enable plugins and theme..."
ZSHRC="$HOME/.zshrc"

# Backup the original .zshrc file
cp "$ZSHRC" "${ZSHRC}.backup.$(date +%Y%m%d%H%M%S)"

# Update the plugins line in .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"

# Update the theme in .zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="materialshell"/' "$ZSHRC"

echo "Installation and configuration complete!"
echo "Please log out and log back in to start using ZSH with Oh My Zsh."
echo "If you want to start using ZSH right now without logging out, run: exec zsh"