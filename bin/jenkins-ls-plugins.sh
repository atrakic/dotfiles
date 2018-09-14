#/usr/bin/env bash

set -e

# https://github.com/jenkinsci/docker

user=${user:-"admin"}
pass=${pass:-"admin"}
host=${host:-"localhost"}
port=${port:-"8080"}

JENKINS_HOST=$user:$pass@$host:$port
curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'
