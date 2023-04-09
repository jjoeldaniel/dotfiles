!#!/bin/bash

# Install NerdFonts for p10k
/bin/bash -c "$(git clone --depth=1 https://github.com/romkatv/nerd-fonts.git)"
/bin/bash -c "$(cd nerd-fonts)"
/bin/bash -c "$(./build 'Meslo/S/*')"

