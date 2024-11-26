#!/usr/bin/env sh
# Description of the script.
# docker: configuration and utility settings

# Set the Docker configuration directory using XDG Base directory specification.
export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"

# Aliases for Docker operations:

# View running containers with scrolling
alias dps="docker ps | less -S"

# Pull images and list running containers
alias dcup="docker compose pull && docker compose ps --format '{{.Names}}'"

# Run the container top utility from within docker
alias ctop='docker run -it --rm --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'
