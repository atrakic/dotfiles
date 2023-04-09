#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

user=$1
server=$2

cd $HOME
rsync -azHv --delete --progress --numeric-ids -e 'ssh -vvv -p 22' $HOME $user@$server:/Users/$user/backup-$(hostname)
