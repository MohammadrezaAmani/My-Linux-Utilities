#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

install_package() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 is not installed. Installing..."
        if [ -f /etc/debian_version ]; then
            apt-get install -y "$1"
        elif [ -f /etc/fedora-release ]; then
            dnf install -y "$1"
        elif [ -f /etc/arch-release ]; then
            pacman -S --noconfirm "$1"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install "$1"
        else
            echo "Unsupported distribution."
            exit 1
        fi
    else
        echo "$1 is already installed."
    fi
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        if [ -f /etc/debian_version ]; then
            apt-get update
            apt-get install -y docker.io
            systemctl enable --now docker
        elif [ -f /etc/fedora-release ]; then
            dnf install -y docker
            systemctl enable --now docker
        elif [ -f /etc/arch-release ]; then
            pacman -S --noconfirm docker
            systemctl enable --now docker
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install --cask docker
        fi
        echo "Docker installed and started."
    else
        echo "Docker is already installed."
    fi
}

install_nekoray() {
    if ! command -v nekoray &> /dev/null; then
        echo "Installing Nekoray..."
        if [ -f /etc/debian_version ]; then
            curl -fsSL https://nekoray.com/install.sh | bash
        elif [ -f /etc/fedora-release ]; then
            curl -fsSL https://nekoray.com/install.sh | bash
        elif [ -f /etc/arch-release ]; then
            curl -fsSL https://nekoray.com/install.sh | bash
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install nekoray
        fi
        echo "Nekoray installed."
    else
        echo "Nekoray is already installed."
    fi
}

install_ssh() {
    if ! command -v sshd &> /dev/null; then
        echo "Installing OpenSSH Server..."
        if [ -f /etc/debian_version ]; then
            apt-get install -y openssh-server
        elif [ -f /etc/fedora-release ]; then
            dnf install -y openssh-server
        elif [ -f /etc/arch-release ]; then
            pacman -S --noconfirm openssh
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install openssh
        fi
        systemctl enable --now ssh
        echo "OpenSSH Server installed and started."
    else
        echo "OpenSSH Server is already installed."
    fi
}

install_editor() {
    read -p "Do you prefer Vim or Neovim? (vim/neovim): " editor_choice
    if [ "$editor_choice" == "neovim" ]; then
        install_package neovim
        echo "Neovim installed."
    else
        install_package vim
        echo "Vim installed."
    fi
}

install_micro() {
    if ! command -v micro &> /dev/null; then
        echo "Installing micro..."
        curl https://getmic.ro | bash
        mv micro /usr/local/bin
        echo "Micro installed."
    else
        echo "Micro is already installed."
    fi
}

install_git() {
    install_package git
    echo "Git installed."
}

install_utilities() {
    echo "Installing utilities..."
    install_package curl
    install_package wget
    install_package git
    install_package tree
    install_package htop
    install_package unzip
    install_package build-essential
}

customize_settings() {
    read -p "Do you want to customize Zsh theme? (y/n): " theme_choice
    if [ "$theme_choice" == "y" ]; then
        echo "Please choose a theme from: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes"
        read -p "Enter the theme name: " theme_name
        sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$theme_name\"/" $HOME/.zshrc
        echo "Theme set to $theme_name."
    fi
}

if [ -f /etc/debian_version ]; then
    echo "Debian-based distribution detected (e.g. Ubuntu)."
elif [ -f /etc/fedora-release ]; then
    echo "Fedora-based distribution detected."
elif [ -f /etc/arch-release ]; then
    echo "Arch-based distribution detected."
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
else
    echo "Unsupported distribution."
    exit 1
fi

install_zsh
install_docker
install_nekoray
install_ssh
install_editor
install_micro
install_git
install_utilities
customize_settings

echo "Setup complete! Please restart your terminal to apply changes."
