import subprocess
import os
from rich.console import Console
from rich.progress import Progress


def install_package(package):
    try:
        subprocess.run(["sudo", "-S", "dnf", "install", package, "-y"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
    except subprocess.CalledProcessError:
        pass


console = Console()

# Define command-to-package mapping
command_packages = {
    "zsh": "zsh",
    "bat": "bat",
    "make": "make",
    "automake": "automake",
    "gcc": "gcc",
    "gcc-c++": "gcc-c++",
    "valgrind": "valgrind",
    "exa": "exa",
    "navi": "navi",
    "thefuck": "thefuck",
    "autojump": "autojump-zsh",
    "java": "java-latest-openjdk.x86_64",
    "node": "nodejs",
    "nvim": "neovim",
    "neofetch": "neofetch",
    "gh": "gh"
}

with Progress() as progress:
    task = progress.add_task("[cyan]Installing packages...", total=len(command_packages) + 6)

    # Check for rustup and install if we don't have it
    if not subprocess.run(["which", "rustup"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
        subprocess.run(["curl", "--proto", "=https", "--tlsv1.2", "-sSf", "https://sh.rustup.rs", "|", "sh"], check=True)
    progress.update(task, advance=1)

    # Install antigen
    antigen_path = os.path.expanduser("~/dotfiles/antigen.zsh")
    if not os.path.exists(antigen_path):
        with open(antigen_path, "wb") as f:
            subprocess.run(["curl", "-L", "git.io/antigen"], stdout=f, check=True)
    progress.update(task, advance=1)

    # Link files
    subprocess.run(["rm", "-f", os.path.expanduser("~/.zshrc")], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    subprocess.run(["ln", "-s", os.path.expanduser("~/dotfiles/.zshrc"), os.path.expanduser("~/.zshrc")], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    progress.update(task, advance=2)

    # Install packages based on the command-to-package mapping
    for command, package in command_packages.items():
        if not subprocess.run(["command", "-v", command], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
            install_package(package)
        progress.update(task, advance=1)

    if not subprocess.run(["which", "lazygit"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
        subprocess.run(["sudo", "dnf", "copr", "enable", "atim/lazygit", "-y"], check=True)
        install_package("lazygit")
        progress.update(task, advance=1)

    # Set default shell to zsh
    zsh_path = subprocess.run(["which", "zsh"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True).stdout.strip()
    subprocess.run(["chsh", "-s", zsh_path], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    progress.update(task, advance=1)

    # Setup Neovim Config
    if not subprocess.run(["which", "nvim"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
        repo_url = "https://github.com/jjoeldaniel/kickstart.nvim.git"
        target_dir = os.path.expanduser("~/.config/nvim")
    progress.update(task, advance=1)
