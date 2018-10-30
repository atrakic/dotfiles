# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr

# jessfraz popcorns
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

alias grep='grep --color=auto '
alias g="git"
alias h="history"

# List only directories
# shellcheck disable=SC2139
alias lsd="ls -lhF ${colorflag} | grep --color=never '^d'"

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Lock the screen (when going AFK)
alias afk="i3lock -c 000000"

# copy working directory
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  # shellcheck disable=SC2139,SC2140
  alias "$method"="lwp-request -m \"$method\""
done

alias cheat_python="curl cheat.sh/python/"

alias gitls-ls='ls `git ls-files`'

# replace foo with bar occurences in git
function sed-git-simple() {
  if [ -z "${1}" ] || [ -z "${2}" ]; then
     echo "Usage: \`sed-git-simple foo bar\`"
     return 1
  fi
  sed -i 's#"\$1"#\"$2"#g' $(git ls-files)
}

# Create a git.io short URL
function gitio() {
  if [ -z "${1}" ] || [ -z "${2}" ]; then
     echo "Usage: \`gitio slug github url\`"
     return 1
  fi
  curl -i https://git.io/ -F "code=${1}" -F "url=${2}"
}

function gitcommitall() {
  git add .
  if [ -n "$2" ];then 
    git commit -m "$2"
  else
    git commit -m 'Update'
  fi
  #git pull
  #git push
}
