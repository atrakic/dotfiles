#!/usr/bin/env bash

set -e

DOCKER=postgres
POSTGRES_PASSWORD="test"
POSTGRES_USER="test"

docker pull ${DOCKER}

docker volume create "${DOCKER}"-data

docker run -it -d \
    --label "$DOCKER" \
    --name "$DOCKER" \
    --rm \
    -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD=}" \
    -e POSTGRES_USER="${POSTGRES_USER}" \
    -p 5432:5432 \
    -v "${DOCKER}"-data:/var/lib/postgresql/data \
  ${DOCKER}


echo PGHOST=0.0.0.0
echo PGUSER=${POSTGRES_USER}
echo PGPASSWORD=${POSTGRES_PASSWORD}
echo PGDATABASE=postgres
