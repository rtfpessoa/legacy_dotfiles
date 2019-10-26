# Typos
alias docekr='docker'

# Why not?
alias :q='exit'

# ls alias
alias l='ls -lisah'
alias lsorted='ls -lisaht'

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

# Zippin
alias tgz='tar -zcvf'
# Unzippin
alias tuz='tar -xvf'

# Let the games begin
alias k9='kill -9'
alias sk9='sudo k9'
alias ka9='killall -9'
alias ska9='sudo ka9'

# Just the weather
alias meteo='curl -4 wttr.in/Lisbon'

# Sometimes I forget
alias where=which

alias hosts='sudo $EDITOR /etc/hosts'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# All the dig info
alias dig="dig +nocmd any +multiline +noall +answer"

# File size
alias fs="stat -f \"%z bytes\""

# Just MacOS
if test "$OPERATING_SYSTEM" = "Darwin"; then
	# Typos
	alias brwe="brew"

	# Finder
	alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
	alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

	# Mac OS DNS Cache Reset
	alias dns-reset-cache='sudo killall -HUP mDNSResponder'

	# Homebrew
	alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'

	# Empty the Trash on all mounted volumes and the main HDD. then clear the useless sleepimage
	alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash; sudo rm /private/var/vm/sleepimage"

	# Flush Directory Service cache
	alias flush="dscacheutil -flushcache"

	# Recursively delete `.DS_Store` files
	alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
fi
