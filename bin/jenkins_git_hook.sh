#!/bin/bash

# ~project_name/.git/hooks/post-commit

host=${1:-"localhost"}
port=${2:-"8080"}

user=${3:-"git"}
pass=${4:-"pass"}

BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
PIPELINE="myhookpipeline"

curl -XPOST -u "$user:$pass" http://"${host}":"${port}"/job/"${PIPELINE}"/build
echo "Build triggered successfully on branch: $BRANCHNAME"
