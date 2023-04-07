#!/bin/sh

# Install dev tools
/bin/bash -c "$(sudo dnf install gcc-c++)"
/bin/bash -c "$(sudo dnf install valgrind)"
