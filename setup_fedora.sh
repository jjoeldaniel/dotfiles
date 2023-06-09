#!/bin/bash
set -e

# Update
sudo -S dnf update -y

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
["tldr"]="tealdeer"
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
    sudo dnf -S copr enable atim/lazygit -y
    sudo dnf -S install lazygit -y
fi

# Setup neovim config
rm -rf $HOME/.config/nvim
repo_url="https://github.com/jjoeldaniel/kickstart.nvim.git"
target_dir="$HOME/.config/nvim"
git clone --depth=1 "$repo_url" "$target_dir"

# Setup pyenv
if ! which pyenv &>/dev/null; then
  sudo -S dnf install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-devel libnsl2-devel -y
  curl https://pyenv.run | bash
fi

# Install Docker Engine
if ! which docker &>/dev/null; then
  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager \
      --add-repo \
      https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
fi

# Expand HDD size (server stuff)
sudo lvextend /dev/mapper/fedora-root -l+100%FREE
sudo xfs_growfs /dev/mapper/fedora-root

# Setup projects directory
mkdir $HOME/projects

# Link files
rm -f "$HOME/.zshrc"
ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

# Set default shell to zsh
chsh -s $(which zsh)
