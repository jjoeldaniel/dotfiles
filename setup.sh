#!/bin/bash
set -e

# Function to install packages
install_package() {
sudo -S dnf install "$1" -y
}

# Define command-to-package mapping
declare -A command_packages=(
["zsh"]="zsh"
["bat"]="bat"
["make"]="make"
["automake"]="automake"
["gcc"]="gcc"
["gcc-c++"]="gcc-c++"
["valgrind"]="valgrind"
["exa"]="exa"
["navi"]="navi"
["thefuck"]="thefuck"
["autojump"]="autojump-zsh"
["java"]="java-latest-openjdk.x86_64"
["node"]="nodejs"
["nvim"]="neovim"
["neofetch"]="neofetch"
["gh"]="gh"
["rg"]="ripgrep"
)

# Install packages based on the command-to-package mapping

for command in "${!command_packages[@]}"; do
if ! command -v "$command" &>/dev/null; then
install_package "${command_packages[$command]}"
fi
done

# Check for rustup and install if we don't have it
if ! which rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install antigen
antigen_path="$HOME/dotfiles/antigen.zsh"
if [[ ! -f "$antigen_path" ]]; then
  curl -L git.io/antigen -o "$antigen_path"
fi

# Install lazygit
if ! which lazygit >/dev/null; then
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install lazygit
fi

# Setup neovim config
if ! which nvim >/dev/null; then
    repo_url="https://github.com/jjoeldaniel/kickstart.nvim.git"
    target_dir="$HOME/.config/nvim"
    git clone --depth=1 "$repo_url" "$target_dir"
fi

# Link files
rm -f "$HOME/.zshrc"
ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

# Set default shell to zsh
chsh -s $(which zsh)
