# __terragrunt__

alias terragrunt="tg"
tg() {
  <<TG
#!/bin/bash

## persist downloaded plugins
##export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

#if ! tg-path-checker .
#then
#  exit 1
#  fi

$(aws ecr get-login --no-include-email) >/dev/null
docker pull 608844984558.dkr.ecr.eu-west-1.amazonaws.com/aws:latest

envfile="/tmp/environment-${USER}-${XDG_SESSION_ID}"
env > "$envfile"

# ensure that the .terragrunt dir exists
mkdir -p ~/.terragrunt
if [ "$SSH_AUTH_SOCK" ]
then
   SSH_VOLUME="--volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent"
fi

docker run -it --rm \
    --workdir $(pwd) \
    --volume ${HOME}:/home/${USER}:Z \
    --volume cache${USER}${XDG_SESSION_ID}:/home/${USER}/.terragrunt:Z \
    --env-file "$envfile" \
    --env USERGID=$(id -g) \
    --env USERUID=$(id -u) \
    $SSH_VOLUME \
   608844984558.dkr.ecr.eu-west-1.amazonaws.com/aws:latest /run.sh terragrunt "$@"
TG
}

export TF_LOG=info

alias tg-plan="terragrunt plan"
alias tg-plan-suni="terragrunt plan --terragrunt-source-update --terragrunt-non-interactive"
alias tg-plan-all="terragrunt plan-all"
alias tg-plan-all-suni="terragrunt plan-all --terragrunt-source-update --terragrunt-non-interactive"

alias tg-apply="terragrunt apply"
alias tg-apply-suni="terragrunt apply --terragrunt-source-update --terragrunt-non-interactive -input=false -no-color"
alias tg-apply-all="terragrunt apply-all"
alias tg-apply-all-suni="terragrunt apply-all --terragrunt-source-update --terragrunt-non-interactive -input=false -no-color"

alias tg-destroy="terragrunt destroy"
alias tg-destroy-all="terragrunt destroy-all --terragrunt-non-interactive -force" #  -get-plugins=false

alias tg-output="terragrunt output"
alias tg-show="terragrunt show"
alias tg-state-list="terragrunt state list"
alias tg-force-unlock="terragrunt force-unlock" # $<id>

alias tg-show-find-execdir="find . -name terraform.tfvars -execdir terragrunt show {} ';'"
alias tg-plan-find-execdir="find . -name terraform.tfvars -execdir terragrunt plan --terragrunt-source-update --terragrunt-non-interactive {} ';'"
alias tg-apply-find-execdir="find . -name terraform.tfvars -execdir terragrunt apply --terragrunt-source-update --terragrunt-non-interactive {} ';'"
alias tg-walk-apply-all="f() {for i in $@;do echo '$i'; pushd '$i';tg apply-all --terragrunt-source-update --terragrunt-non-interactive; popd; done};f"

alias tg-example='f() { echo Your arg was $@ };f'
alias tg-foo='TF_VAR_foo_1=bar_1 TF_VAR_foo_2=bar_2 tg apply --terragrunt-source-update --terragrunt-non-interactive'

alias tf-validate="terraform validate -check-variables=false"
alias tf-fmt="terraform fmt"

# __terragrunt__