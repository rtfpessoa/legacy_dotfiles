#!/bin/sh

#
# OS X Shell Settings
#

# Force my HOME (sudo compatibility)
export DEFAULT_USER="rtfpessoa"

# Want your terminal to support 256 color schemes? I do ...
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
export EDITOR="vim"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  export HOME="/home/$DEFAULT_USER"

  # Java
  export JAVA_HOME=/usr/lib/jvm/java-8-oracle
  export JDK_HOME="${JAVA_HOME}"
  export JRE_HOME="${JAVA_HOME}/jre"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export HOME="/Users/$DEFAULT_USER"

  # Java
  export JAVA_HOME="$(/usr/libexec/java_home --failfast)"
  export JDK_HOME="${JAVA_HOME}"
  export JRE_HOME="${JAVA_HOME}/jre"
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
  force_clean=$3
  dockerFullName="codacy/$dockerName:$dockerVersion"
  if [ -n "${force_clean}" ]; then docker rmi -f $dockerFullName; fi
  sbt "set version in Docker := \"$dockerVersion\"" "set name := \"$dockerName\"" docker:publishLocal
  docker tag $dockerName:$dockerVersion $dockerFullName
  docker rmi -f $dockerName:$dockerVersion
}

function dockerbuild {
  dockerName=$1
  dockerVersion=$2
  force_clean=$3
  dockerFullName="codacy/$dockerName:$dockerVersion"
  if [ -n "${force_clean}" ]; then docker rmi -f $dockerFullName; fi
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
alias dkrclean='docker system prune --all -f'

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Docker for Mac
  alias docker-ssh='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'

  # Sublime
  PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin

  # Finder
  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

  # Mac OS DNS Cache Reset
  alias dns-reset-cache='sudo killall -HUP mDNSResponder'
fi

# Copy cmds
alias dklogs='docker logs --tail 10000 -f $(docker ps -q -a)'
function cpdklogs() {
  echo 'docker logs --tail 10000 -f $(docker ps -q -a)' | pbcopy
}

# Tmux shortcuts
# creates a new tmux session without name
alias tmx='tmux new'
# creates a new tmux session named session_name
alias tmxn='tmux new -d -s'
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

# Composer
PATH=$PATH:$HOME/.composer/vendor/bin

# Atom
alias atom-backup='apm list --installed --bare > Atomfile'
alias atom-restore='apm install --packages-file Atomfile'

# GO
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH=$HOME/.go

alias youtube-dl-playlist='youtube-dl -i --yes-playlist -c --no-check-certificate --prefer-insecure -x --no-post-overwrites --audio-format mp3 --audio-quality 256K -o '"'"'%(upload_date)s - %(title)s - %(id)s.%(ext)s'"'"''

alias pip-install='sudo python3 -m pip install --ignore-installed --no-cache-dir --upgrade'

alias yarn-upgrade='cat package.json | jq -r '"'"'.dependencies | keys | .[]'"'"' | xargs yarn add'
alias yarn-upgrade-dev='cat package.json | jq -r '"'"'.devDependencies | keys | .[]'"'"' | xargs yarn add --dev'

# Why not?
alias :q='exit'

# Zippin
alias tgz='tar -zcvf'
# Unzippin
alias tuz='tar -xvf'

# Let the games begin
alias k9='kill -9'
alias sk9='sudo k9'
alias ka9='killall -9'
alias ska9='sudo ka9'

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew cask cleanup && brew prune && brew doctor'

# Timer
timed() {
  { time ( $@ ) } 2>&1
}

# Visual Studio Code
vsc () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Just the weather
alias meteo='curl -4 wttr.in/Lisbon'

# My Binaries
PATH="$PATH:$HOME/.bins"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export XDG_DATA_DIRS="${HOME}/.linuxbrew/share:$XDG_DATA_DIRS"
  PATH=${HOME}/.linuxbrew/bin:${GOPATH//://bin:}/bin:$PATH
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PATH=/usr/local/bin:/usr/local/sbin:${GOPATH//://bin:}/bin:$PATH
fi

if [[ -s "$HOME/.nodenv/bin/nodenv" ]]; then
  path=("$HOME/.nodenv/bin" $path)
  eval "$($HOME/.nodenv/bin/nodenv init - --no-rehash zsh)"
fi

if which yarn &> /dev/null; then
  PATH="$HOME/.config/yarn/global/node_modules/.bin:$HOME/.nodenv/shims:$PATH"
fi

if [[ -s "$HOME/.rbenv/bin/rbenv" ]]; then
  path=("$HOME/.rbenv/bin" $path)
  eval "$($HOME/.rbenv/bin/rbenv init - --no-rehash zsh)"
fi

# Python
PATH="/usr/local/opt/python@2/bin:$PATH"
if [[ -s "$HOME/.pyenv/bin/pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  path=("$PYENV_ROOT/bin" $path)
  eval "$($HOME/.pyenv/bin/pyenv init - --no-rehash zsh)"
fi

# Rust
PATH="$HOME/.cargo/bin:$PATH"

# Export the PATH
export PATH

tmuxed() {
  if [[ "$OSTYPE" =~ "darwin" && "$ZSH_NAME" = "zsh" && -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$SSH_TTY" ]]; then
    tmux_session='rtfpessoa'
    tmux start-server

    # Create a '$tmux_session' session if no session has been defined in tmux.conf
    if ! tmux has-session 2> /dev/null; then
      tmux_session='rtfpessoa'
      tmux new-session -d -s "$tmux_session"
    fi

    # Attach to last session
    # exec tmux attach -t "$tmux_session"
    tmux attach -t "$tmux_session"
  fi
}

# tmuxed
