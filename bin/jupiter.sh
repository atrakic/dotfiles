#!/usr/bin/env bash

set -e

DOCKER=jupiter-minimal

#docker volume create "${DOCKER}"-data

docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -p 8080:8080 \
    -v "$HOME":/home \
    jupyter/minimal-notebook
