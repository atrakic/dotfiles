# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
[ -d $HOME/.pyenv ] && export PYENV_ROOT="$HOME/.pyenv"
[ -d $HOME/.pyenv/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"

# git clone https://github.com/bash-my-aws/bash-my-aws.git ~/.bash-my-aws
[ -d $HOME/.bash-my-aws/bin ] && export PATH="$HOME/.bash-my-aws/bin:$PATH"

[ -d $HOME/.pulumi/bin ] && export PATH="$HOME/.pulumi/bin:$PATH"
