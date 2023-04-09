#!/bin/sh

# Install dev tools
sudo dnf install gcc-c++
sudo dnf install valgrind

# Setup sshd config and restart ssh
sudo cp sshd_config /etc/ssh/
sudo service ssh restart
