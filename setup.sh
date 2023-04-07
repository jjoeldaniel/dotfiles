#!/bin/sh

echo "Setting up Linux..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check for rustup and install if we don't have it
if test ! $(which rustup); then
  /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s .zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Installs antigen
/bin/bash -c "$(curl -L git.io/antigen > antigen.zsh)"

# Installs nitch (system fetcher)
/bin/bash -c "$(wget https://raw.githubusercontent.com/unxsh/nitch/main/setup.sh && sh setup.sh)"

# Install NeoVim
if test ! $(which nvim); then
  /bin/bash -c "$(brew install neovim --HEAD)"
fi

# Setup Neovim Config
REPO_URL="git@github.com:jjoeldaniel/kickstart.nvim.git"
TARGET_DIR="$HOME/.config/nvim"

if [ -d "$TARGET_DIR" ]; then
  /bin/bash -c "$(rm -rf "$TARGET_DIR")"
fi

/bin/bash -c "$(git clone "$REPO_URL" "$TARGET_DIR")"

# Install NerdFonts for p10k
/bin/bash -c "$(git clone --depth=1 https://github.com/romkatv/nerd-fonts.git)"
/bin/bash -c "$(cd nerd-fonts)"
/bin/bash -c "$(./build 'Meslo/S/*')"

# Setup sshd config and restart ssh
/bin/bash -c "$(cp sshd_config /etc/ssh/)"
/bin/bash -c "$(sudo service ssh restart)"
