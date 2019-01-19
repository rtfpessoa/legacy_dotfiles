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
export VISUAL="vim"
export GREP_COLOR='1;33'

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  export HOME="/home/$DEFAULT_USER"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export HOME="/Users/$DEFAULT_USER"
fi

# ls alias
alias l='ls -lisah'

# SBT shortcuts
alias sbtclean='rm -rf $(find . -type d -iname target)'

add_to_path() {
    if test -d "$1"; then
        export PATH="$1:$PATH"
    fi
}

# docker alias
alias docekr='docker'

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Finder
  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

  # Mac OS DNS Cache Reset
  alias dns-reset-cache='sudo killall -HUP mDNSResponder'
fi

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
alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'

# Timer
timed() {
  { time ( $@ ) } 2>&1
}

# Visual Studio Code
vsc () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Visual Studio Code
if [[ "$OSTYPE" == "darwin"* ]]; then
  code() {
    local VSCODE_PATH "/Applications/Visual\ Studio\ Code.app/Contents"
    local ELECTRON "$VSCODE_PATH/MacOS/Electron"
    local CLI "$VSCODE_PATH/Resources/app/out/cli.js"
    ELECTRON_RUN_AS_NODE=1 "$ELECTRON" "$CLI" "$@"
  }
elif [[ "$OSTYPE" == "Linux" ]]; then
  code() {
    local VSCODE_PATH "/usr/share/code"
    local ELECTRON "$VSCODE_PATH/code"
    local CLI "$VSCODE_PATH/resources/app/out/cli.js"
    ELECTRON_RUN_AS_NODE=1 "$ELECTRON" "$CLI" "$@"
  }
fi

# Just the weather
alias meteo='curl -4 wttr.in/Lisbon'

# Composer
add_to_path "$HOME/.composer/vendor/bin"

# GO
if [[ "$OSTYPE" == "darwin"* ]]; then
  export GOROOT="/usr/local/opt/go/libexec"
fi
export GOPATH=$HOME/.go

add_to_path "$GOPATH/bin"
add_to_path "/usr/local/sbin"
add_to_path "/usr/local/bin"
add_to_path "/usr/local/opt/coreutils/libexec/gnubin"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

if test -s "$HOME/.nodenv"; then
    add_to_path "$HOME/.nodenv/bin"
    add_to_path "$HOME/.nodenv/shims"
    eval "$($HOME/.nodenv/bin/nodenv init - --no-rehash $SHELL)"
fi

if which yarn 2>&1 >/dev/null; then
    add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
fi

if test -s "$HOME/.rbenv"; then
    add_to_path "$HOME/.rbenv/bin"
    add_to_path "$HOME/.rbenv/shims"
    eval "$($HOME/.rbenv/bin/rbenv init - --no-rehash $SHELL)"
fi

# Python
add_to_path "/usr/local/opt/python@2/bin"
if test -s "$HOME/.pyenv/bin/pyenv"; then
    export PYENV_ROOT="$HOME/.pyenv"
    add_to_path "$PYENV_ROOT/bin"
    eval "$($HOME/.pyenv/bin/pyenv init - --no-rehash $SHELL)"
fi

# Java
if test -s "$HOME/.jabba/jabba.sh"; then
    source "$HOME/.jabba/jabba.sh"
fi

# krypt.co
export GPG_TTY=$(tty)

# Rust
add_to_path "$HOME/.cargo/bin"

# Export the PATH
export PATH

tmuxed() {
  if [[ "$ZSH_NAME" != "zsh" && "$SHELL" != "fish" ]]; then return; fi
  if [[ ! "$OSTYPE" =~ "darwin" ]]; then return; fi

  if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$SSH_TTY" ]]; then
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
