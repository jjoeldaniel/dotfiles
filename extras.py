from package import which, cmd
import os


def install_rust():
    if which("rustup"):
        return

    # Install rustup
    cmd("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")

    # Enable rustup completions
    cmd("mkdir -p ~/.config/fish/completions")
    cmd("rustup completions fish > ~/.config/fish/completions/rustup.fish")


def change_shell():
    # Switch to fish shell
    if os.environ["SHELL"] != "/usr/bin/fish":
        cmd("chsh -s $(which fish)")


def install_neovim_config():
    # Install neovim config
    cmd("rm -rf ~/.config/nvim")
    cmd("git clone https://github.com/jjoeldaniel/nvim ~/.config/nvim")


def install_node():
    # Install latest Node
    if not which("node"):
        cmd("nvm install latest")


def install_extras():
    install_rust()
    change_shell()
    install_neovim_config()
    install_node()
