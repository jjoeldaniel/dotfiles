#!/bin/sh

# Install dev tools
/bin/bash -c "$(sudo dnf install gcc-c++)"
/bin/bash -c "$(sudo dnf install valgrind)"

# Setup sshd config and restart ssh
/bin/bash -c "$(cp sshd_config /etc/ssh/)"
/bin/bash -c "$(sudo service ssh restart)"
