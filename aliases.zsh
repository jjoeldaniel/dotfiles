# Shortcuts
alias c="clear"
alias reloadshell="source $HOME/.zshrc"

# Directories
alias dotfiles="cd $DOTFILES"

# SSH Key Generation
alias keygen="ssh-keygen -t ed25519"

# thefuck 
alias fk="fuck"

# lazygit
alias lg="lazygit"

# exa
alias ls="exa"
alias tree="exa -T -L"

# bat
alias cat="bat -p"

# ddgr
alias google="ddgr"

# setup venv and install dependencies
alias venv="[ ! -d "venv" ] && python3 -m venv venv && source venv/bin/activate && [ -e "requirements.txt" ] && pip install -r requirements.txt || [ -d venv ] && source venv/bin/activate"
