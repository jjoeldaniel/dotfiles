#!/bin/bash

echo "Setting up Linux..."

# Check for rustup and install if we don't have it
if test ! $(which rustup); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Installs antigen
rm -f $HOME/antigen.zsh
curl -L git.io/antigen > $HOME/antigen.zsh

# Link .zshrc 
rm -f $HOME/.zshrc
ln -s dotfiles/.zshrc ~/.zshrc

# Copies over necessary files
rm -f $HOME/aliases.zsh
# cp ./.zshrc $HOME/.zshrc
cp ./aliases.zsh $HOME/aliases.zsh

# install all the tools
command -v zsh || sudo dnf install zsh -y
command -v bat || sudo dnf install bat -y
command -v make || sudo dnf install make -y
command -v automake || sudo dnf install automake -y
command -v gcc || sudo dnf install gcc -y
command -v gcc-c++ || sudo dnf install gcc-c++ -y
command -v valgrind || sudo dnf install valgrind -y
command -v tldr || cargo install tealdeer
command -v exa || sudo dnf install exa -y
command -v navi || sudo dnf install navi -y
command -v thefuck || sudo dnf install thefuck -y
command -v autojump || sudo dnf install autojump-zsh -y
command -v java || sudo dnf install java-latest-openjdk.x86_64 -y
command -v node || sudo dnf install nodejs -y
command -v nvim || sudo dnf install neovim -y

sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

# set default shell to zsh
chsh -s $(which zsh)

# Setup Neovim Config
if test ! $(which nvim); then
  REPO_URL="https://github.com/jjoeldaniel/kickstart.nvim.git"
  TARGET_DIR="$HOME/.config/nvim"

  if [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  fi

  git clone "$REPO_URL" "$TARGET_DIR"
fi
