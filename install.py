from package import Package, Packages
from extras import install_extras
import os


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
            elif includes_header and not header_encountered:
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


def main():
    debug: bool = False
    paths = [f for f in os.listdir("./") if f.endswith(".jcsv")]

    for path in paths:
        packages: Packages = collect_packages(path, debug=debug)
        packages.install()

    install_extras()


if __name__ == "__main__":
    main()
