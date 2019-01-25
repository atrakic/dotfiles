#!/usr/bin/env bash

set -e

DOCKER=evergreen

docker volume create "${DOCKER}"-data

docker run -it -d \
    --name "$DOCKER" \
    -p 8080:8080 \
    -p 5000:5000 \
    -v $(which docker):/bin/docker \
    -v "${DOCKER}"-data:/${DOCKER}/data/ \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e LOG_LEVEL=debug \
    jenkins/$DOCKER:docker-cloud
#    --restart=always \
#    -v "$(pwd)/seed":/var/jenkins_home/workspace/seed \
#    -v "$HOME":/home \
# docker exec $DOCKER cat /evergreen/data/jenkins/home/secrets/initialAdminPassword
