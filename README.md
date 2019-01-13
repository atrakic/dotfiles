# Dotfiles
This repository contains configuration files used in Linux env.

## Prerequisites
- git

# Install

To install, run:

```console

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

echo ".cfg" >> .gitignore

git clone --bare https://github.com/atrakic/dotfiles.git $HOME/.cfg

config checkout

```

# Credits
* https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
