import pprint
import subprocess
from enum import Enum
import shutil


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
