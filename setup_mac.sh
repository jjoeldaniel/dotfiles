#!/bin/bash
set -e

brew update && brew upgrade

# Function to install packages
install_package() {
brew install "$1"
}

# Define command-to-package mapping
declare command_packages=(
["bat"]="bat"
["make"]="make"
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
["lazygit"]="lazygit"
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

# Setup neovim config
rm -rf $HOME/.config/nvim
repo_url="https://github.com/jjoeldaniel/kickstart.nvim.git"
target_dir="$HOME/.config/nvim"
git clone --depth=1 "$repo_url" "$target_dir"

# Setup pyenv
brew install openssl readline sqlite3 xz zlib tcl-tk
curl https://pyenv.run | bash

# Link files
rm -f "$HOME/.zshrc"
ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
