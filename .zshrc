if [[ -f /.dockerenv ]]; then
  export ZSH=/root/.oh-my-zsh 
else  
  export ZSH=/home/admir/.oh-my-zsh
fi

ZSH_THEME="agnoster"

DISABLE_AUTO_UPDATE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  git-extras
  python
  docker
  docker-compose
  kubectl
  helm
  dotenv
  terraform
  aws
)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH

alias dotconfig='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias pwd-localhost-run='python3 -m http.server &; ssh -R 80:localhost:8000 ssh.localhost.run'
alias klocal='KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl'

which direnv &>/dev/null && eval "$(direnv hook zsh)"
which hcloud &>/dev/null && source <(hcloud completion zsh)

[ -f ~/.zshenv ] && source ~/.zshenv
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.dockerfunc ] && source ~/.dockerfunc
[ -f ~/.bash-my-aws/bash_completion.sh ] && source ~/.bash-my-aws/bash_completion.sh
[ -f  /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh
[ -f ~/.kubectl_aliases ] && source <(cat ~/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
PS1='$(show_virtual_env)'$PS1

function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }

[[ -d /keys ]] && [ ! -z "$(ls -A /keys)" ] && eval `ssh-agent -s` && ssh-add /keys/*

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  #eval "$(pyenv virtualenv-init -)"
fi
