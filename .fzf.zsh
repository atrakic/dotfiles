# Setup fzf
# ---------
if [[ ! "$PATH" == */home/admir/.fzf/bin* ]]; then
  export PATH="$PATH:/home/admir/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/admir/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/admir/.fzf/shell/key-bindings.zsh"

