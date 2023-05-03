#!/bin/bash
set -e

# Update
sudo apt update -y && sudo apt upgrade -y

# Function to install packages
install_package() {
sudo apt install "$1" -y
}

# Define command-to-package mapping
declare -A command_packages=(
["zsh"]="zsh"
["bat"]="bat"
["gcc"]="build-essential"
["valgrind"]="valgrind"
["exa"]="exa"
["navi"]="navi"
["thefuck"]="thefuck"
["autojump"]="autojump-zsh"
["java"]="openjdk-17-jre-headless"
["node"]="nodejs"
["neofetch"]="neofetch"
["gh"]="gh"
["rg"]="ripgrep"
)

# Function to install snaps
install_snap() {
sudo -S snap "$1" -y
}

declare -A snap_packages=(
["node"]="node --classic"
["nvim"]="nvim --edge --classic"
)

# Install packages based on the command-to-package mapping
for command in "${!command_packages[@]}"; do
if ! command -v "$command" &>/dev/null; then
install_package "${command_packages[$command]}"
fi
done

for command in "${!snap_packages[@]}"; do
if ! command -v "$command" &>/dev/null; then
install_snap "${snap_packages[$command]}"
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
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
fi

if ! which tldr >/dev/null; then
  cargo install tealdeer
fi

# Setup neovim config
rm -rf $HOME/.config/nvim
repo_url="https://github.com/jjoeldaniel/kickstart.nvim.git"
target_dir="$HOME/.config/nvim"
git clone --depth=1 "$repo_url" "$target_dir"

# Setup pyenv
if ! which pyenv &>/dev/null; then
  curl https://pyenv.run | bash
fi

# Link files
rm -f "$HOME/.zshrc"
ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

# Set default shell to zsh
chsh -s $(which zsh)
