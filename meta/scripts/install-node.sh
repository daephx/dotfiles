#!/usr/bin/env bash
set -e

# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Source profile after script changes
source "$HOME/.profile"

# Install nodejs long-term-support branch
nvm install --lts

# Alias the current node version to default
node_version=$(node --version | cut -c2-)
nvm alias default $node_version
