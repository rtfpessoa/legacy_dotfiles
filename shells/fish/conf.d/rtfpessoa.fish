#!/usr/bin/env fish

#
# Shell Settings
#

# Force my HOME (sudo compatibility)
set -gx DEFAULT_USER rtfpessoa

# Want your terminal to support 256 color schemes? I do ...
set -gx TERM xterm-256color
set -gx CLICOLOR 1
set -gx OPERATING_SYSTEM (uname)

# Languages
set -gx LANG en_US.UTF-8
set -gx LC_COLLATE en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx LC_MESSAGES en_US.UTF-8
set -gx LC_MONETARY en_US.UTF-8
set -gx LC_NUMERIC en_US.UTF-8
set -gx LC_TIME en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Editor
set -gx EDITOR vim
set -gx VISUAL vim
set -gx GREP_COLOR '1;33'

switch "$OPERATING_SYSTEM"
    case Linux
        # Linux
        set -gx HOME "/home/$DEFAULT_USER"

        # Java
        set -gx JAVA_HOME /usr/lib/jvm/java-8-oracle
        set -gx JDK_HOME "$JAVA_HOME"
        set -gx JRE_HOME "$JAVA_HOME/jre"

    case Darwin
        # Mac OSX
        set -gx HOME "/Users/$DEFAULT_USER"

        # Java
        set -gx JAVA_HOME (/usr/libexec/java_home --failfast)
        set -gx JDK_HOME "$JAVA_HOME"
        set -gx JRE_HOME "$JAVA_HOME/jre"
end

# ls alias
alias l='ls -lisah'
alias lise='ls -lisa'
alias lsa='ls -a'

# SBT shortcuts
alias sbtc='sbt compile'
alias sbtcc='sbt "~compile"'
alias sbtclean='rm -rf (find . -type d -iname target)'

function list_paths
    echo $fish_user_paths | tr " " "\n" | nl
end

function erase_path
    set --erase --universal fish_user_paths[$argv[1]]
end

function add_to_path
    if test -d "$argv[1]"
        set -gx fish_user_paths "$argv[1]" $fish_user_paths
    end
end

function varclear --description 'Remove duplicates from environment variable'
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                set count (math $count+1)
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        test $count -gt 0
        and echo Removed $count duplicates from $argv
    else
        for a in $argv
            varclear $a
        end
    end
end

function orDefault
    set -q $argv[1]
    and echo $$argv[1]
    or echo $argv[2]
end

function sbtdocker
    set dockerName $argv[1]
    set dockerVersion $argv[2]
    set force_clean $argv[3]
    set dockerFullName "codacy/$dockerName:$dockerVersion"
    if test -n "$force_clean"
        docker rmi -f $dockerFullName
    end
    sbt "set version in Docker := \"$dockerVersion\"" "set name := \"$dockerName\"" docker:publishLocal
    docker tag $dockerName:$dockerVersion $dockerFullName
    docker rmi -f $dockerName:$dockerVersion
end

function dockerbuild
    set dockerName $argv[1]
    set dockerVersion $argv[2]
    set force_clean $argv[3]
    set dockerFullName "codacy/$dockerName:$dockerVersion"
    if test -n "$force_clean"
        docker rmi -f $dockerFullName
    end
    docker build --rm=true -t $dockerFullName .
end

# docker alias
alias docekr='docker'

switch "$OPERATING_SYSTEM"
    case Darwin
        # Docker for Mac
        alias docker-ssh='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'

        # Finder
        alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
        alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

        # Mac OS DNS Cache Reset
        alias dns-reset-cache='sudo killall -HUP mDNSResponder'
end

# Copy cmds
alias dklogs='docker logs --tail 10000 -f (docker ps -q -a)'
function cpdklogs
    echo 'docker logs --tail 10000 -f (docker ps -q -a)' | pbcopy
end

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
add_to_path "$HOME/.composer/vendor/bin"

# GO
set -gx GOROOT "/usr/local/opt/go/libexec"
set -gx GOPATH "$HOME/.go"

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
alias brewu='brew update; and brew upgrade; and brew cleanup; and brew cask cleanup; and brew prune; and brew doctor'

# Visual Studio Code
switch "$OPERATING_SYSTEM"
    case Darwin
        function code
            begin
                set CONTENTS "/Applications/Visual\ Studio\ Code.app/Contents"
                set ELECTRON "$CONTENTS/MacOS/Electron"
                set CLI "$CONTENTS/Resources/app/out/cli.js"
                set -lx ELECTRON_RUN_AS_NODE 1
                eval "$ELECTRON" "$CLI" "$argv"
            end
        end
end

# Just the weather
alias meteo='curl -4 wttr.in/Lisbon'

add_to_path "$GOPATH/bin"
add_to_path "$HOME/.bins"
add_to_path "/usr/local/sbin"
add_to_path "/usr/local/bin"
add_to_path "/usr/local/opt/coreutils/libexec/gnubin"

set -gx MANPATH "/usr/local/opt/coreutils/libexec/gnuman" $MANPATH

if test -s "$HOME/.nodenv"
    add_to_path "$HOME/.nodenv/bin"
    add_to_path "$HOME/.nodenv/shims"
    source (eval $HOME/.nodenv/bin/nodenv init - --no-rehash fish | psub)
end

if which yarn 2>&1 >/dev/null
    add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
end

if test -s "$HOME/.rbenv"
    add_to_path "$HOME/.rbenv/bin"
    add_to_path "$HOME/.rbenv/shims"
    source (eval $HOME/.rbenv/bin/rbenv init - --no-rehash fish | psub)
end

# Python
add_to_path "/usr/local/opt/python@2/bin"
if test -s "$HOME/.pyenv/bin/pyenv"
    set -gx PYENV_ROOT "$HOME/.pyenv"
    add_to_path "$PYENV_ROOT/bin"
    source (eval $HOME/.pyenv/bin/pyenv init - --no-rehash fish | psub)
end

# krypt.co
set -gx GPG_TTY (tty)

# Rust
add_to_path "$HOME/.cargo/bin"

function tmuxed
    if string match -i 'Darwin' "$OPERATING_SYSTEM"
        and string match -i "*fish" "$SHELL"
        and test -z "$TMUX"
        and test -z "$EMACS"
        and test -z "$VIM"
        and test -z "$SSH_TTY"

        set tmux_session 'rtfpessoa'
        tmux start-server

        # Create a '$tmux_session' session if no session has been defined in tmux.conf
        if not tmux has-session 2>/dev/null
            tmux new-session -d -s "$tmux_session"
        end

        # Attach to last session
        # exec tmux attach -t "$tmux_session"
        tmux attach -t "$tmux_session"
    end
end

# tmuxed
