# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr

if [ -d "$HOME/.linkerd2" ]; then export PATH=$PATH:$HOME/.linkerd2/bin; fi
if [ -d "$HOME/.jx/bin" ]; then export PATH=$PATH:$HOME/.jx/bin; fi

DEVBOX_HOME="/opt/toolbox"
if [ -d "$DEVBOX_HOME/bin" ]; then 
  export PATH="$DEVBOX_HOME/bin:$PATH"; 
fi
