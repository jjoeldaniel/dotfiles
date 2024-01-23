import shutil
import pprint
import os
import subprocess

# TODO:
# Install neovim config
# Install Rust


def cmd(args: str):
    subprocess.run(
        args,
        stdout=subprocess.DEVNULL,
        shell=True,
        executable="/usr/bin/fish",
    )


def fisher_which(command: str) -> bool:
    output = cmd("fisher list")
    return True if f"/{command}" in str(output) else False


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
            try:
                cmd(args=f"{install_command} {self.name}")
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


def collect_packages(path: str, debug: bool = False) -> Packages:
    # Package name : Command name
    packages: list[Package] = list()
    install_command: str | None = None

    with open(path, "r") as f:
        header_encountered: bool = False

        for x in f.readlines():
            if x.startswith("#") or x.strip() == "":
                continue

            if not install_command:
                install_command = x.strip()
            elif not header_encountered and x.strip() != "":
                header_encountered = True
            else:
                if x.strip() == "":
                    continue

                parse = x.strip().split(",")
                packages.append(
                    Package(name=parse[0].strip(), command=parse[1].strip())
                )

    if not install_command:
        raise Exception("No installation command found!")

    if debug:
        [print(f"{p.name}: {p.command}") for p in packages]

    return Packages(install_command, packages)


def main():
    debug: bool = False
    paths = [f for f in os.listdir("./") if f.endswith(".jcsv")]

    for path in paths:
        packages: Packages = collect_packages(path, debug=debug)
        packages.install()

    # Switch to fish shell
    if os.environ["SHELL"] != "/usr/bin/fish":
        cmd("chsh -s $(which fish)")

    if not which("node"):
        cmd("nvm install latest")


if __name__ == "__main__":
    main()
