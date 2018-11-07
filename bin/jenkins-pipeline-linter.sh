#!/usr/bin/env bash

set -e

# https://jenkins.io/doc/book/pipeline/development/#linter

user=${user:-"admin"}
pass=${pass:-"admin"}
host=${host:-"localhost"}
port=${port:-"8080"}

Jenkinsfile=${1:-"Jenkinsfile"}

JENKINS_URL="http://$user:$pass@$host:$port"

JENKINS_CRUMB=$(curl -s "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
curl -X POST -H "$JENKINS_CRUMB" -F "jenkinsfile=<$Jenkinsfile" "${JENKINS_URL}"/pipeline-model-converter/validate
