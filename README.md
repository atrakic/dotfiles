# Dotfiles
This repository contains my configuration files used in Linux env.

## Prerequisites
- git

# Install

To install, run:

```console

alias dotconfig='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

echo ".cfg" >> .gitignore

git clone --bare https://github.com/atrakic/dotfiles.git $HOME/.cfg

dotconfig checkout

```

# Add/edit with config files

```console

dotconfig add .foo/bar_config
dotconfig commit -m "Added .foo/bar_config
dotconfig push
...

```

# Credits
* https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
