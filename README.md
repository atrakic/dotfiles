# Dotfiles

![DockerCI](https://github.com/atrakic/dotfiles/workflows/DockerCI/badge.svg)

My configuration files used in Linux env (image size ~1.6Gb).

## Features
- latest Ubuntu
- nvim editor with custom configuration
- Golang
- Pyton3
- Ansible with collections 
- zsh as default shell

## Build and run with Docker + DockerCompose

Build:

```console

docker-compose build
```

Run (requires directory with ssh-keys and aws configs):

```console

./bin/dotfiles.sh

```

## Install on local machine without docker

```console

# cd $HOME

# pull the repo
git clone --bare https://github.com/atrakic/dotfiles.git $HOME/.cfg

echo ".cfg" >> .gitignore

# Setup alias 
alias dotconfig='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# use alias
dotconfig checkout

```

## How to add/edit config files

```console

dotconfig add .foo/bar_config
dotconfig commit -m "Added .foo/bar_config
dotconfig push
...

```

## Credits
* https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
