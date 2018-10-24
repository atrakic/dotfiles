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

DOCKER_MACHINE_VERSION="v0.15.0"
DOCKER_COMPOSE_VERSION="1.22.0"
KUBECTL_VERSION=v1.11.2 # v1.10.0
MINIKUBE_VERSION=latest # `minikube version`
TG_VERSION=v0.13.0
# --

function install_docker_machine() {
  local bin=docker-machine
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    base=https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_VERSION &&
    curl -sL $base/docker-machine-"$(uname -s)"-"$(uname -m)" -o "$file" &&
    chmod +x "$file" && echo "Installed $bin version: $DOCKER_MACHINE_VERSION"
  fi
}

function install_helm() {
  local bin=helm
  local file=$DIR/$bin
  if [ ! -x "$(which $file)" ] || [ "$force" ]; then
      export HELM_INSTALL_DIR=$DIR
      curl -sL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
      echo "Installed $bin version $VERSION"
      # minikube addons enable registry-creds
      # helm init --upgrade && helm repo update
  fi
}

function install_terragrun() {
  local bin=terragrunt
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/"$TG_VERSION"/terragrunt_linux_amd64 -o "$file"
    chmod +x "$file" && echo "Installed $bin version: $TG_VERSION"
  fi
}

function install_docker_machine_driver_kvm() {
  local bin=docker-machine-driver-kvm2
  local DIR=/usr/local/bin
  file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    curl -sLo /tmp/docker-machine-driver-kvm2 https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2
    chmod +x /tmp/docker-machine-driver-kvm2
    sudo mv -f /tmp/docker-machine-driver-kvm2 /usr/local/bin/ && echo "Installed $bin version: $VERSION"
  fi
}

function install_minikube() {
  local bin=minikube
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    curl -sL https://storage.googleapis.com/minikube/releases/"$MINIKUBE_VERSION"/minikube-linux-amd64 -o "$file"
    chmod +x "$file" && echo "Installed $bin version: $MINIKUBE_VERSION"
    minikube version
    minikube config set WantReportErrorPrompt false
    if [ "$INSTALL_KVM" ]; then
      install_docker_machine_driver_kvm
      minikube config set vm-driver kvm2
    fi
  fi
}

function install_kubectl() {
  local bin=kubectl
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    curl -sL https://storage.googleapis.com/kubernetes-release/release/"$KUBECTL_VERSION"/bin/linux/amd64/kubectl -o "$file"
    chmod +x "$file" && echo "Installed $bin version: $KUBECTL_VERSION"
  fi
}

function install_docker_compose() {
  local bin=docker-compose
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    curl -sL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o "$file"
    chmod +x "$file" && echo "Installed $bin version: $DOCKER_COMPOSE_VERSION"
  fi
}

function install_vault() {
  local bin=vault
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{vault}' |egrep "linux_amd64" |grep url | egrep -v "beta|alpha"| sort -rV | head -1 | awk -F[\"] '{print $4}')
    cd /tmp || exit 1
    rm -rf $bin
    curl -o $bin.zip -sL "${url}"
    unzip -o $bin.zip
    mv -f "$bin" "$DIR" && echo "Installed $bin version: $VERSION"
    rm -rf $bin.zip
  fi
}

function install_terraform() {
  local bin=terraform
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{terraform}' |egrep "linux_amd64" |grep url | egrep -v "beta|alpha" | sort -rV | head -1 | awk -F[\"] '{print $4}')
    cd /tmp/ || exit 1
    rm -rf $bin
    curl -o $bin.zip -sL "${url}"
    unzip -o $bin.zip
    mv -f "$bin" "$DIR" && echo "Installed $bin version: $VERSION"
    rm -rf $bin.zip
  fi
}

function install_packer() {
  local bin=packer
  local file=$DIR/$bin
  if [ ! -x "$file" ] || [ "$force" ]; then
    url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' |egrep "linux_amd64" |grep url | egrep -v "beta|alpha" | sort -rV | head -1 | awk -F[\"] '{print $4}')
    cd /tmp/ || exit 1
    curl -o $bin.zip -sL "${url}"
    unzip -o $bin.zip
    mv -f "$bin" "$DIR"
    chmod +x "$file" && echo "Installed $bin version: $VERSION"
    rm -rf $bin.zip
  fi
}

function main() {
  mkdir -p "$DIR" || exit 1
  printf "${green}Installing toolbox on: $DIR${neutral}\n"

  install_docker_machine
  install_helm
  install_terragrun
  install_docker_machine_driver_kvm
  install_minikube
  install_kubectl
  install_docker_compose
  install_vault
  install_terraform
  install_packer

  cd "$DIR"
  other_bins="https://storage.googleapis.com/bin.kuar.io/cfssl
    https://storage.googleapis.com/bin.kuar.io/cfssljson"

  for url in ${other_bins[@]}; do
    curl -sO "$url" && chmod +x *
  done

  echo "$DIR"
  export PATH=$DIR:$PATH

  test "$(which pip)" && pip install --upgrade pip
  test "$(which pip)" && pip install --user awscli ansible request
}

main "$@"
