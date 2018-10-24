#!/usr/bin/env bash

set -e

DOCKER=portainer

docker volume create "${DOCKER}"-data

docker volume create portainer_data
docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -p 9000:9000 \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -v "${DOCKER}"-data:/data \
  portainer/portainer
