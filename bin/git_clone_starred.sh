#!/bin/bash

USER=${1:-atrakic}
STARS=$(curl -sI https://api.github.com/users/$USER/starred?per_page=1|egrep '^Link'|egrep -o 'page=[0-9]+'|tail -1|cut -c6-)
PAGES=$((658/100+1))
echo You have $STARS starred repositories.
echo

PER_PAGE=10
PAGES=$((658/$PER_PAGE+1))
for PAGE in `seq $PAGES`; do
  curl -s "https://api.github.com/users/$USER/starred?per_page=$PER_PAGE&page=$PAGE" | jq -r '.[] | (.html_url) + " " + (.full_name)' | xargs -L1 -P4 git clone
done
echo

find .  -mindepth 2 -maxdepth 3 -type d  -execdir git pull \;
