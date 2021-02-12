# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
[ -d $HOME/.pyenv ] && export PYENV_ROOT="$HOME/.pyenv"
[ -d $HOME/.pyenv/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"

[ -d $HOME/.bash-my-aws/bin ] && export PATH="$HOME/.bash-my-aws/bin:$PATH"
[ -f $HOME/.bash-my-aws/aliases ] && source ~/.bash-my-aws/aliases

# git clone https://github.com/bash-my-aws/bash-my-aws.git ~/.bash-my-aws
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
[ -f $HOME/.bash-my-aws/bash_completion.sh ] && source $HOME/.bash-my-aws/bash_completion.sh
