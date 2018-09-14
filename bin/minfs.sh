#!/bin/bash

# create the single node swarm machine
docker-machine create -d virtualbox \
      --virtualbox-cpu-count "2" \
      --virtualbox-memory "1024" \
      --virtualbox-ui-type "headless" \
      postgres-machine

# source environment variables
eval $(docker-machine env postgres-machine)

# Get machine IP
MINIO_IP=$(docker-machine ip postgres-machine)

# install minio/minfs plugin
docker-machine ssh postgres-machine \
    docker plugin install --grant-all-permissions minio/minfs

# initialize swarm mode
docker-machine ssh postgres-machine \
    docker swarm init \
        --listen-addr ${MINIO_IP} \
        --advertise-addr ${MINIO_IP}

# create access keys
MINIO_ACCESS_KEY=$(openssl rand -hex 10)
MINIO_SECRET_KEY=$(openssl rand -hex 15)

# create overlay network
docker network create --driver overlay postgres-network

# create local volumes for minio-server
docker volume create --driver local minio-config
docker volume create --driver local minio-data

# create a minio server at first
docker service create -d \
    --name minio \
      --replicas 1 \
      --network postgres-network \
      -p 9000:9000  \
      --mount "type=volume,src=minio-data,dst=/storage" \
      --mount "type=volume,src=minio-config,dst=/root/.minio" \
      -e "MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}" \
      -e "MINIO_SECRET_KEY=${MINIO_SECRET_KEY}" \
      minio/minio server /storage

# wait for service to spin up
echo ""
echo ">> Waiting for Minio to come up (may take a while)..."
while ! nc -z ${MINIO_IP} 9000; do
    sleep 1
done

echo ">> Minio service logs"
docker service logs minio

# then create a volume to back up Postgresql data
echo ""
echo ">> Create Postgres volume ..."
docker volume create \
    -d minio/minfs \
      --name postgres-data \
        -o endpoint=http://${MINIO_IP}:9000 \
          -o access-key=${MINIO_ACCESS_KEY} \
            -o secret-key=${MINIO_SECRET_KEY} \
              -o bucket=postgres-data
  # -o opts=uid=999,gid=999

# lanuch the Postgres server and connect to minio
echo ""
echo ">> Starting Postgres server ..."
docker service create -d \
    --name postgres \
      --replicas 1 \
        --network postgres-network \
          -p 5432:5432  \
            --mount "type=volume,src=postgres-data,dst=/var/lib/postgresql/data" \
              -e "POSTGRES_USER=admin" \
                -e "POSTGRES_PASSWORD=changeit" \
                  postgres:9.6.4-alpine

echo ""
echo "Now look into the service logs of postgres and you´ll find the err"
