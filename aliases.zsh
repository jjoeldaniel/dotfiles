# Shortcuts
alias c="clear"
alias reloadshell="source $DOTFILES/.zshrc"

# Directories
alias dotfiles="cd $DOTFILES"

# SSH Key Generation
alias keygen="ssh-keygen -t ed25519"

# thefuck 
alias fk="fuck"

# podman
alias docker="podman"

# git
alias pull="git pull"
alias fetch="git fetch"
alias commit="git commit -m"
alias push="git push"

# lazygit
alias lg="lazygit"

# exa
alias ls="exa"
alias tree="exa -T -L"

# bat
alias cat="bat -p"

# setup venv
alias venv="[ ! -d "venv" ] && python3 -m venv venv && source venv/bin/activate || [ -d venv ] && source venv/bin/activate"
