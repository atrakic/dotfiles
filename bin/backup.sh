#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

user=$(whoami)
server=192.168.1.64

ssh -o PasswordAuthentication=no -o BatchMode=yes "$user"@"$server" true || exit
cd "$HOME"

# brew bundle dump

for i in \
  ".github" ".git-hooks" ".gitconfig" ".gitmessage"\
  "./Documents" \
  "./go/src" \
  "./Library/helm" "./Library/Preferences" \
  ".azure" ".github" ".docker" ".terraformrc" \
  ".vim" ".vimrc" "./Downloads" \
  ".github" ".tigrc" ".config" \
  ".krew" ".oh-my-zsh" ".zshrc" ".zsh_history" \
  ".argocd" ".kube" \
  ".local" "./bin" "./Projects" \
  "./Library/Application Support"; do
  rsync -avzHvP --delete --progress --numeric-ids -e 'ssh -vvv -p 22' --rsync-path=/opt/bin/rsync "$i" "$user"@"$server":/volume1/homes/"$user"
done
