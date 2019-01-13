# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# <Stil.dk> 
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/stil/bin:$HOME/bin:$PATH"
fi

# bash completion for check_mk
if [ -f ~/.check_mk.d/check_mk.completion.bash ];then
  source ~/.check_mk.d/check_mk.completion.bash 
fi 

# Vagrant: 
if [ -f  ~/.vagrant_completition/completion.sh ]; then
  source ~/.vagrant_completition/completion.sh 
fi

# GIT complete 
if [ -f /usr/share/bash-completion/completions/gitk ]; then 
  source /usr/share/bash-completion/completions/gitk; 
fi 

# The next line updates PATH for the Google Cloud SDK.
#if [ -f /home/admir/local/google-cloud-sdk/path.bash.inc ]; then
#  source '/home/admir/local/google-cloud-sdk/path.bash.inc'
#fi

# The next line enables shell command completion for gcloud.
#if [ -f /home/admir/local/google-cloud-sdk/completion.bash.inc ]; then
#  source '/home/admir/local/google-cloud-sdk/completion.bash.inc'
#fi

if [ -f $HOME/.terraform.d/terraform.completion.bash ]; then 
  source $HOME/.terraform.d/terraform.completion.bash
fi 

if [ -f $HOME/bin/ansible-completion.bash.txt ]; then
  source $HOME/bin/ansible-completion.bash.txt
  export ANSIBLE_NOCOWS=1
fi 

# added by travis gem
[ -f /home/admir/.travis/travis.sh ] && source /home/admir/.travis/travis.sh

# echo "profile $(basename $0)" 

# ssh-key without passphrase 
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
  # test: 
  ssh-add -l
fi

#export PS1='\e[1m\e[31m[\h] \e[32m(\\\$(docker-prompt)) \e[34m\u@{}\e[35m \w\e[0m\n$ '

# easygit package
#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
PS1='\[\e]0;\u@\h: \w\a\]$(__git_ps1 "(%s)")\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# ssh-key with passphrase, with keychain 
# eval `keychain --eval id_rsa`

### AWS setup 
complete -C '$(which aws_completer)' aws
#export HTTPS_PROXY=http://username:password@w.x.y.z:m
#export AWS_SECRET_ACCESS_KEY=""
#export AWS_ACCESS_KEY_ID=""
# A session token is only required if you are using temporary security credentials
#export AWS_SESSION_TOKEN= 
# export AWS_DEFAULT_REGION=
# path to a CLI config file
# export AWS_CONFIG_FILE=
export AWS_DEFAULT_PROFILE=awsadmir
#export NO_PROXY=169.254.169.254
# __done__ 


# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
source ~/.autoenv/activate.sh
alias config='/usr/bin/git --git-dir=/home/admir/.cfg/ --work-tree=/home/admir'
