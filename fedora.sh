#!/bin/sh

# Install dev tools
/bin/bash -c "$(sudo dnf install gcc-c++)"
/bin/bash -c "$(sudo dnf install valgrind)"

# Install Docker
/bin/bash -c"$(sudo dnf -y install dnf-plugins-core)"
/bin/bash -c"$(sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo)"
/bin/bash -c"$(sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)"
