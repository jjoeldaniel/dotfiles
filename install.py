import shutil
import pprint
import os
import subprocess
from enum import Enum


class Shell(Enum):
    BASH = "/bin/bash"
    FISH = "/usr/bin/fish"


def cmd(args: str, shell: Shell = Shell.BASH):
    subprocess.run(args, stdout=subprocess.DEVNULL, shell=True, executable=shell.value)


def fisher_which(command: str) -> bool:
    return True if f"/{command}" in str(cmd("fisher list", shell=Shell.FISH)) else False


def which(command: str, install_command: str | None = None) -> bool:
    if install_command and "fisher" in install_command:
        return fisher_which(command)
    else:
        return True if shutil.which(command) else False


class Package:
    def __init__(self, name: str, command: str) -> None:
        self.name: str = name
        self.command: str = command

    def install(self, install_command: str):
        if not which(self.command, install_command):
            shell: Shell = Shell.FISH if "fish" in install_command else Shell.BASH
            try:
                cmd(args=f"{install_command} {self.name}", shell=shell)
            except subprocess.CalledProcessError as e:
                print(f"Installing command {e.cmd} failed with error {e.returncode}")

    def __repr__(self) -> str:
        return pprint.pformat({self.name: self.command})


class Packages:
    def __init__(self, install_command: str, packages: list[Package]):
        self.install_command = install_command
        self.packages = packages

    def install(self):
        [p.install(self.install_command) for p in self.packages]

    def __repr__(self) -> str:
        return pprint.pformat(
            {
                "install_command": self.install_command,
                "packages": self.packages,
            }
        )


def collect_packages(
    path: str, debug: bool = False, includes_header: bool = True
) -> Packages:
    # Package name : Command name
    packages: list[Package] = list()
    install_command: str | None = None

    with open(path, "r") as f:
        header_encountered: bool = False
        multiline_comment: bool = False

        for x in f.readlines():
            # Skip comments and empty lines
            if x.startswith("###"):
                multiline_comment = not multiline_comment
                continue
            if multiline_comment:
                continue
            if x.startswith("#") or x.strip() == "":
                continue

            # Parse out installation command and CSV headers
            if not install_command:
                install_command = x.strip()
            elif includes_header and not header_encountered and x.strip() != "":
                header_encountered = True
            # Parse data
            else:
                parse = x.strip().split(",")
                packages.append(
                    Package(name=parse[0].strip(), command=parse[1].strip())
                )

    if not install_command:
        raise Exception("No installation command found!")

    if debug:
        [print(f"{p.name}: {p.command}") for p in packages]

    return Packages(install_command, packages)


def install_rust():
    if which("rustup"):
        return

    # Install rustup
    cmd("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")

    # Enable rustup completions
    cmd("mkdir -p ~/.config/fish/completions")
    cmd("rustup completions fish > ~/.config/fish/completions/rustup.fish")


def main():
    debug: bool = False
    paths = [f for f in os.listdir("./") if f.endswith(".jcsv")]

    for path in paths:
        packages: Packages = collect_packages(path, debug=debug)
        packages.install()

    # Switch to fish shell
    if os.environ["SHELL"] != "/usr/bin/fish":
        cmd("chsh -s $(which fish)")

    # Install latest Node
    if not which("node"):
        cmd("nvm install latest")

    # Install neovim config
    cmd("rm -rf ~/.config/nvim")
    cmd("git clone https://github.com/jjoeldaniel/nvim ~/.config/nvim")

    # Install rustup
    install_rust()


if __name__ == "__main__":
    main()
