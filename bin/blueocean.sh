#!/usr/bin/env bash

set -e

DOCKER=blueocean

docker pull jenkinsci/${DOCKER}

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
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$HOME":/home \
    jenkinsci/$DOCKER
#    --privileged=true \
#    -v "$(pwd)/seed":/var/jenkins_home/workspace/seed \
# curl --user 'username:password' --data-urlencode "script=$(< ./somescript.groovy)" https://localhost:8080/scriptText
