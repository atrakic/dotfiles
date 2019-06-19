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

# 
docker exec -it $DOCKER apk add gettext make
PASS=$(docker exec -it $DOCKER cat /var/jenkins_home/secrets/initialAdminPassword)
# curl --user 'admin:$PASS' --data-urlencode "script=$(< ./init.groovy)" https://localhost:8080/scriptText
