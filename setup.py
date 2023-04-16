import subprocess
import os


def install_package(package):
    try:
        subprocess.run(["sudo", "dnf", "install", package, "-y"], check=True)
    except subprocess.CalledProcessError:
        pass


# Check for rustup and install if we don't have it
if not subprocess.run(["which", "rustup"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
    subprocess.run(["curl", "--proto", "=https", "--tlsv1.2", "-sSf", "https://sh.rustup.rs", "|", "sh"], check=True)

# Install antigen
antigen_path = os.path.expanduser("~/dotfiles/antigen.zsh")
if not os.path.exists(antigen_path):
    with open(antigen_path, "wb") as f:
        subprocess.run(["curl", "-L", "git.io/antigen"], stdout=f, check=True)

# Link files
subprocess.run(["rm", "-f", os.path.expanduser("~/.zshrc")], check=True)
subprocess.run(["ln", "-s", os.path.expanduser("~/dotfiles/.zshrc"), os.path.expanduser("~/.zshrc")], check=True)

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
    "autojump-zsh": "autojump-zsh",
    "java": "java-latest-openjdk.x86_64",
    "node": "nodejs",
    "nvim": "neovim",
    "neofetch": "neofetch",
    "gh": "gh"
}

# Install packages based on the command-to-package mapping
for command, package in command_packages.items():
    if not subprocess.run(["command", "-v", command], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
        install_package(package)

subprocess.run(["sudo", "dnf", "copr", "enable", "atim/lazygit", "-y"], check=True)
install_package("lazygit")

# Set default shell to zsh
zsh_path = subprocess.run(["which", "zsh"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True).stdout.strip()
subprocess.run(["chsh", "-s", zsh_path], check=True)

# Setup Neovim Config
if not subprocess.run(["which", "nvim"], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout:
    repo_url = "https://github.com/jjoeldaniel/kickstart.nvim.git"
    target_dir = os.path.expanduser("~/.config/nvim")

    if not os.path.exists(target_dir):
        subprocess.run(["rm", "-rf", target_dir], check=True, shell=True)
    subprocess.run(["git", "clone", repo_url, target_dir], check=True)

