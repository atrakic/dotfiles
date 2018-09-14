#!/usr/bin/env bash

# Install:
# sudo mkdir -p /opt/toolbox
# sudo chown -R $(whoami):$(whoami) /opt/toolbox

# set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

DIR=${DIR:-"/opt/toolbox/bin"}
force=${force:-"true"}

DOCKER_COMPOSE_VERSION="1.22.0"
KUBECTL_VERSION=v1.11.2 # v1.10.0
MINIKUBE_VERSION=v0.28.2
TG_VERSION=v0.13.0

mkdir -p "$DIR" || exit 1
printf ${green}"Installing toolbox on: $DIR"${neutral}"\n"

bin=helm
file=$DIR/$bin
if [ ! -x "$(which $file)" ] || [ "$force" ]; then
    export HELM_INSTALL_DIR=$DIR
    curl -sL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
    echo "Installed $bin version $VERSION"
    # minikube addons enable registry-creds
    # helm init --upgrade && helm repo update
fi

bin=terragrunt
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/"$TG_VERSION"/terragrunt_linux_amd64 -o "$file"
  chmod +x "$file" && echo "Installed $bin version: $TG_VERSION"
fi

bin=minikube
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  curl -sL https://storage.googleapis.com/minikube/releases/"$MINIKUBE_VERSION"/minikube-linux-amd64 -o "$file"
  chmod +x "$file" && echo "Installed $bin version: $MINIKUBE_VERSION"
fi

bin=kubectl
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  curl -sL https://storage.googleapis.com/kubernetes-release/release/"$KUBECTL_VERSION"/bin/linux/amd64/kubectl -o "$file"
  chmod +x "$file" && echo "Installed $bin version: $KUBECTL_VERSION"
fi

bin=docker-compose
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  curl -sL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o "$file"
  chmod +x "$file" && echo "Installed $bin version: $DOCKER_COMPOSE_VERSION"
fi

bin=terraform
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{terraform}' |egrep "linux_amd64" |grep url | grep -v beta | sort -rV | head -1 | awk -F[\"] '{print $4}')
  cd /tmp/ || exit 1
  rm -rf $bin
  curl -o $bin.zip -sL "${url}"
  unzip -o $bin.zip
  mv -f "$bin" "$DIR" && echo "Installed $bin version: $VERSION"
  rm -rf $bin.zip
fi

bin=packer
file=$DIR/$bin
if [ ! -x "$file" ] || [ "$force" ]; then
  url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' |egrep "linux_amd64" |grep url | sort -rV | head -1 | awk -F[\"] '{print $4}')
  cd /tmp/ || exit 1
  curl -o $bin.zip -sL "${url}"
  unzip -o $bin.zip
  mv -f "$bin" "$DIR"
  chmod +x "$file" && echo "Installed $bin version: $VERSION"
  rm -rf $bin.zip
fi

echo "$DIR"
export PATH=$DIR:$PATH

pip install --upgrade pip
pip install --user awscli ansible
