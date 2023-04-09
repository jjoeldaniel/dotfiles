#!/bin/bash

echo "Setting up Linux..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi

# Check for rustup and install if we don't have it
if test ! $(which rustup); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Copies over necessary files
cp ./.zshrc $HOME/.zshrc
cp ./antigen.zsh $HOME/antigen.zsh
cp ./aliases.zsh $HOME/aliases.zsh

# Update Homebrew recipes
brew update
brew install bat
brew install tldr
brew install tree
brew install thefuck
brew install openjdk
brew install navi
brew install fzf
brew install autojump
brew install tree-sitter
brew install python@3.11
brew install unzip
brew install exa
brew install bat
brew install exiftool
brew install gping
brew install lazygit
brew install lazydocker
brew install node

# Install all our dependencies with bundle (See Brewfile)
# brew tap homebrew/bundle
# brew bundle --file ./Brewfile

# Installs antigen
curl -L git.io/antigen > antigen.zsh

# Install NeoVim
if test ! $(which nvim); then
  brew install neovim --HEAD

  # Setup Neovim Config
  REPO_URL="git@github.com:jjoeldaniel/kickstart.nvim.git"
  TARGET_DIR="$HOME/.config/nvim"

  if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
  fi

  git clone "$REPO_URL" "$TARGET_DIR"

fi
