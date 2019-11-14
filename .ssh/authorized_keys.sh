#!/bin/bash

# set -eu

#AuthorizedKeysCommand /usr/local/bin/userkeys.sh %u
#AuthorizedKeysCommandUser nobody

USER=${1:-atrakic}
curl -sf https://api.github.com/users/"$USER"/keys |jq -r '.[].key'
