#!/usr/bin/env bash

set -e

DOCKER=blueocean

docker volume create "${DOCKER}"-data

docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -u root \
    -e LOG_LEVEL=debug \
    -p 8080:8080 \
    -p 5000:5000 \
    -v $(which docker):/bin/docker \
    -v "${DOCKER}"-data:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v "$HOME":/home \
    jenkinsci/$DOCKER
#    -v "$(pwd)/seed":/var/jenkins_home/workspace/seed \
