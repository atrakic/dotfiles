#!/usr/bin/env bash

# Deploy your container to outside world ;)
#
# Add the following environment variables to your project configuration.
# * DOCKER_CONTAINER
#
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/atrakic/dotfiles/master/bin/localhost.run.sh | bash -s
DOCKER_CONTAINER=${DOCKER_CONTAINER:?"You need to configure the DOCKER_CONTAINER environment variable, eg. 'containous/whoami' !"}
TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-''}  ## man timeout

# Fail the deployment on the first error
set -e

readonly random_port=$RANDOM
readonly local_port=80

docker run -d -p "$random_port":"$local_port" "$DOCKER_CONTAINER"

ssh_args=(-aT -R ${local_port}:localhost:$random_port ssh.localhost.run) ## -fN

if [ -z "$TIMEOUT_SECONDS" ]; then
  ssh "${ssh_args[@]}"
else
  timeout "${TIMEOUT_SECONDS}" ssh "${ssh_args[@]}"
fi
