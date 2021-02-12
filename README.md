# Dotfiles

![DockerCI](https://github.com/atrakic/dotfiles/workflows/DockerCI/badge.svg)

My configuration files used in Linux env.

## Features
- Ubuntu latest
- nvim as IDE 
- Golang
- Pyton3 with batteries included
- Ansible with comunity collections
- zsh as default shell

## Usage (image size ~1.6Gb)

## With Docker

```console

# build image
docker-compose build 

# run container:
./bin/dotfiles.sh

```

## On local machine without docker
* Credits: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

```console

# cd $HOME

# pull the repo
git clone --bare https://github.com/atrakic/dotfiles.git $HOME/.cfg

echo ".cfg" >> .gitignore

# Setup alias 
alias dotconfig='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# use alias
dotconfig checkout

# Add/edit config files
dotconfig add .foo/bar_config
dotconfig commit -m "Added .foo/bar_config
dotconfig push

```
