#!/usr/bin/env bash

set -e

DOCKER=postgres

docker volume create "${DOCKER}"-data

docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -e POSTGRES_PASSWORD="password" \
    -e POSTGRES_USER="user" \
    -p 5432:5432 \
    -v "${DOCKER}"-data:/var/lib/postgresql/data \
  ${DOCKER}
