#!/bin/sh

#
# OS X Shell Settings
#

if [ "$ZSH_NAME" = "zsh" ] && [ "$TMUX" = "" ] && [[ "$OSTYPE" == "darwin"* ]]; then tmux; fi

# Force my HOME (sudo compatibility)
export DEFAULT_USER="rtfpessoa"

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
export EDITOR="vi"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  export HOME="/home/$DEFAULT_USER"

  # Java
  export JAVA_HOME=/usr/lib/jvm/java-8-oracle
  export JDK_HOME=/usr/lib/jvm/java-8-oracle
  export JRE_HOME=/usr/lib/jvm/java-8-oracle/jre
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export HOME="/Users/$DEFAULT_USER"

  # Java
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home
  export JDK_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home
  export JRE_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home/jre
else
  # Unknown.
fi

# ls alias
alias l='ls -lisah'
alias lise='ls -lisa'
alias lsa='ls -a'

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
alias codacyclean='rm -rf $(find . -type d -iname target);rm -rf ~/.sbt/0.13/staging;rm -rf ~/.sbt/0.13/target;rm -rf ~/.ivy2/local;rm -rf ~/.ivy2/cache/codacy;rm -rf ~/.ivy2/cache/com.codacy;'

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

function sbtfastdocker {
  dockerName=$1
  dockerVersion=$2
  repoPrefix=$3
  dockerFullName="${repoPrefix}codacy/$dockerName:$dockerVersion"
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

# docker alias
alias dk='docker'
alias docekr='docker'
alias dki='docker images'
alias dkpsa='docker ps -a'
alias dkrm='docker rm -f'
alias dkrmi='docker rmi -f'
alias dkinspect='docker inspect -f "{{.Config}}" $(docker ps -a -q)'

# Special docker alias
alias dkrmpsexit='docker rm -f $(docker ps -a -q -f status=exited)'
alias dkrmps='docker rm -f $(docker ps -a -q)'
alias dkrminone='docker rmi -f $(docker images | grep "'"^<none>"'" | awk "'"{print $3}"'")'
alias dkrmidang='rmi -f $(docker images -q -f "dangling=true")'

# Copy cmds
alias dklogs='docker logs --tail 10000 -f $(docker ps -q -a)'
function cpdklogs() {
  echo 'docker logs --tail 10000 -f $(docker ps -q -a)' | pbcopy
}

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

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Sublime
  PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin
fi

# Sublime
alias subl='subl -a'

# NPM
PATH="$HOME/.node/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Composer
PATH=$PATH:$HOME/.composer/vendor/bin

# JPM
PATH=$PATH:$HOME/Library/PackageManager/bin

# Atom
alias atom-backup='apm list --installed --bare > Atomfile'
alias atom-restore='apm install --packages-file Atomfile'

# GO
export GOPATH=$HOME/.go

# The Fuck
eval "$(thefuck --alias)"

if which brew &> /dev/null; then
  if brew command command-not-found-init > /dev/null; then eval "$(brew command-not-found-init)"; fi

  # PHP 5.6
  PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"
fi

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
alias fixfinder='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist;sudo rm -rf /.Spotlight-V100;sudo rm -rf /Volumes/Data/.Spotlight-V100;sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist;'

# Homebrew
alias brewu='brew update  && brew upgrade --all && brew cleanup && brew cask cleanup && brew prune && brew doctor'

# rbenv
PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Visual Studio Code
vsc () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Just the weather
alias meteo='curl -4 wttr.in/Lisbon'

# My Binaries
PATH="$PATH:$HOME/.bins"

### HOMEBREW PATH ###
PATH=/usr/local/bin:/usr/local/sbin:${GOPATH//://bin:}/bin:$PATH
### HOMEBREW PATH ###

# Export the PATH
export PATH
