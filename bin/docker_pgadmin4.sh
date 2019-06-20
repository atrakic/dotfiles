#!/usr/bin/env bash

set -ex

DOCKER=pgadmin4

docker volume create "${DOCKER}"-data

docker pull dpage/pgadmin4
docker run -it -d \
    --name "$DOCKER" \
    -e "PGADMIN_DEFAULT_EMAIL=user@domain.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=SuperSecret" \
    -p 8081:80 \
    -v "$HOME":/home \
    -v "${DOCKER}"-data:/var/lib/pgadmin \
    dpage/$DOCKER
    
  echo ""http://www.postgresqltutorial.com/
