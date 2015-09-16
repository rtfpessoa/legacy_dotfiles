#!/bin/sh

#
# OS X Shell Settings
#

if [ "$ZSH_NAME" = "zsh" ] && [ "$TMUX" = "" ]; then tmux; fi

# Force my HOME (sudo compatibility)
export DEFAULT_USER=rtfpessoa
export HOME=/Users/rtfpessoa

# want your terminal to support 256 color schemes? I do ...
export TERM="xterm-256color"
export CLICOLOR=1

# Languages
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR="nano"

# Clean my path
# add usr local bins to the path for bin resulution in this script
usrLocalBin="/usr/local/bin"
usrLocalSbin="/usr/local/sbin"
PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:$HOME/.rbenv/shims:$usrLocalBin:$usrLocalSbin"

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home
export JDK_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home
export JRE_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/jre

# ls alias
alias l='ls -lisah'
alias lise='ls -lisa'
alias lsa='ls -a'

# Play Framework shortcuts
PATH=$PATH:$HOME/qamine/apps/activator

GRC_CONFIG_LOCATION=$HOME/.grc-codacy

alias pl='activator'
alias plc='grc --config=$GRC_CONFIG_LOCATION activator compile'
alias plcc='grc --config=$GRC_CONFIG_LOCATION activator "~compile"'
alias plr='grc --config=$GRC_CONFIG_LOCATION activator run'
alias plrr='grc --config=$GRC_CONFIG_LOCATION activator "~run"'
alias pls='grc --config=$GRC_CONFIG_LOCATION activator start'
alias pld='grc --config=$GRC_CONFIG_LOCATION activator -jvm-debug 9999'
alias pldr='grc --config=$GRC_CONFIG_LOCATION activator -jvm-debug 9999 run'
alias plcl='activator clean'
alias plt='grc --config=$GRC_CONFIG_LOCATION activator test'
alias plco='activator console'
alias plclean='rm -rf $(find . -type d -iname target)'
alias ploff='activator "set offline := true"'

# SBT shortcuts
alias sbtc='sbt compile'
alias sbtcc='sbt "~compile"'
alias sbtr='sbt run'
alias sbtrr='sbt "~run"'
alias sbts='sbt start'
alias sbtd='sbt -jvm-debug 9999'
alias sbtdr='sbt -jvm-debug 9999 run'
alias sbtcl='sbt clean'
alias sbtt='sbt test'
alias sbtco='sbt console'
alias sbtclean='rm -rf $(find . -type d -iname target)'

function sbtdocker {
	dockerName=$1
	dockerVersion=$2
	repoPrefix=$3
	dockerFullName="${repoPrefix}codacy/$dockerName:$dockerVersion"
	docker rmi -f $dockerFullName
	sbt "set version in Docker := \"$dockerVersion\"" "set name := \"$dockerName\"" docker:publishLocal
	docker tag -f $dockerName:$dockerVersion $dockerFullName
	docker rmi -f $dockerName:$dockerVersion
}

function dockerbuild {
	dockerName=$1
	dockerVersion=$2
	repoPrefix=$3
	dockerFullName="${repoPrefix}codacy/$dockerName:$dockerVersion"
	docker rmi -f $dockerFullName
	docker build --rm=true -t $dockerFullName .
}

function sbtdockerr {
	sbtdocker $1 $2 "registry.docker.codacy.io/"
}

function dockerbuildr {
	dockerbuild $1 $2 "registry.docker.codacy.io/"
}

# boot2docker alias
alias dktinit="docker-toolbox-init"
alias dkm="docker-machine"
alias dktenv='eval $(docker-machine env default)'

# docker alias
alias dki='docker images'
alias dkpsa='docker ps -a'
alias dkrm='docker rm -f'
alias dkrmi='docker rmi -f'
alias dkinspect='docker inspect -f "{{.Config}}" $(docker ps -a -q)'

# Special docker alias
alias dkrmpsexit='docker rm -f $(docker ps -a -q -f status=exited)'
alias dkrmps='docker rm -f $(docker ps -a -q)'
alias dkrminone='docker rmi -f $(docker images | grep "^<none>" | awk "{print $3}")'

# Tmux shortcuts
# creates a new tmux session without name
alias tmx='tmux new'
# creates a new tmux session named session_name
alias tmxn='tmux new -s'
# attaches to the first existing tmux session
alias tmxa1='tmux attach'
# attaches to an existing tmux session named session_name
alias tmxa='tmux attach -t'
# switches to an existing session named session_name
alias tmxs='tmux switch -t'
# lists existing tmux sessions
alias tmxl='tmux list-sessions'
# detach the currently attached session
alias tmxd='tmux detach'
# kill session
alias tmxk='tmux kill-session -t'
# create a new window
alias tmxnw='tmux new-window'
# move to the window based on index
alias tmxsw='tmux select-window -t'
# rename the current window
alias tmxrw='tmux rename-window'
# splits the window into two vertical panes
alias tmxsv='tmux split-window'
# splits the window into two horizontal panes
alias tmxsh='tmux split-window -h'
# swaps pane with another in the specified direction -[UDLR] (prefix + { or })
alias tmxswp='tmux swap-pane'
# selects the next pane in the specified direction -[UDLR]
alias tmxsp='tmux select-pane'
# selects the next pane in numerical order
alias tmxspn='tmux select-pane -t'

# AndroidSDK
export ANDROID_HOME=$HOME/Library/Android/sdk
PATH=$PATH:$HOME/Library/Android/sdk/platform-tools

# PMD Copy-Paste Detector
PATH=$PATH:$HOME/qamine/apps/pmd-cpd

# Latex
PATH=$PATH:/Library/TeX/texbin:/usr/texbin

# Sublime
PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin
alias subl='subl -a'

# NVM
export NVM_DIR=$HOME/.nvm
source $(brew --prefix nvm)/nvm.sh

# PHP 5.6
PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"

# Composer
PATH=$PATH:$HOME/.composer/vendor/bin

# JPM
PATH=$PATH:$HOME/Library/PackageManager/bin

# The Fuck
eval "$(thefuck --alias)"

# why not?
alias :q='exit'

# Zippin
alias tgz='tar -zcvf'
# Unzippin
alias tuz='tar -xvf'

# Let the games begin
alias ka9='killall -9'
alias k9='kill -9'

# Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Homebrew
alias brewu='brew update  && brew upgrade --all && brew cleanup && brew cask cleanup && brew prune && brew doctor'

# rbenv
eval "$(rbenv init -)"

# My Binaries
PATH="$PATH:$HOME/.bins"

### HOMEBREW PATH ###
# move usr local bins to the begining of the path
empty_string=""
PATH="${PATH/:$usrLocalBin/$empty_string}"
PATH="${PATH/:$usrLocalSbin/$empty_string}"
PATH=/usr/local/bin:/usr/local/sbin:$PATH
### HOMEBREW PATH ###

# Export the PATH
export PATH

### DOCKER TOOLBOX INIT ###
# dktinit false &>/dev/null
eval $(docker-machine env default 2>/dev/null)
###########################
