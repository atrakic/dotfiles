#!/bin/bash

set -eux pipefail

#AuthorizedKeysCommand /etc/skeys/keylist %u
#AuthorizedKeysCommandUser uucp

USER=${1:-atrakic}

[ $# -ne 1 ] && { echo "Usage: $0 userid" >&2; exit 1; }

case "$USER" in 
  atrakic)
  curl -sf https://api.github.com/users/atrakic/keys |jq -r '.[].key'
  ;;
  *)
  keyfile="/var/lib/keys/$USER.pub"
  [ -f "$keyfile" ] && cat "$keyfile"
	;;
esac
