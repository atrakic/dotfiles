#!/usr/bin/env bash

set -euo pipefail

name=$(whoami)-workstation

#docker volume rm "$name" || true
docker volume create "$name" || true

docker run --name "$name" \
  -v "$HOME"/Projects:/projects \
  -v "$HOME"/.ssh:/keys \
  -v "$HOME"/.aws:/root/.aws:ro \
  -v "$name":/root \
  -v "$(pwd)"/.gitconfig:/root/.gitconfig \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  -e AWS_PROFILE \
  -e SSH_AUTH_SOCK \
  --hostname "$name" \
  --rm -it \
  dotfiles_dotfiles:latest
