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

# Update Homebrew recipes
brew update

if test ! $(which bat); then
  brew install bat
fi

if test ! $(which tldr); then
  brew install tldr
fi

if test ! $(which thefuck); then
  brew install thefuck
fi

if test ! $(which java); then
  brew install openjdk
fi

if test ! $(which navi); then
  brew install navi
fi

if test ! $(which fzf); then
  brew install fzf
fi

if test ! $(which autojump); then
  brew install autojump
fi

if test ! $(which python3); then
  brew install python@3.11
fi

if test ! $(which unzip); then
  brew install unzip
fi

if test ! $(which exa); then
  brew install exa
fi

if test ! $(which exiftool); then
  brew install exiftool
fi

if test ! $(which lazygit); then
  brew install lazygit
fi

if test ! $(which gping); then
  brew install gping
fi

if test ! $(which lazydocker); then
  brew install lazydocker
fi

if test ! $(which node); then
  brew install node
fi

if test ! $(which tree-sitter); then
  brew install tree-sitter
fi

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
