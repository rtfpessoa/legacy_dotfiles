# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something

# Functions
#
# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
function fn() { ls **/*$1* }

# From https://github.com/paulirish/dotfiles/blob/master/.aliases
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias where=which # sometimes i forget
alias brwe=brew  #typos
alias hosts='sudo $EDITOR /etc/hosts'   # yes I occasionally 127.0.0.1 twitter.com ;)

# git root
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# All the dig info
alias dig="dig +nocmd any +multiline +noall +answer"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# Shortcuts
alias g="git"
alias v="vim"

# File size
alias fs="stat -f \"%z bytes\""

# Empty the Trash on all mounted volumes and the main HDD. then clear the useless sleepimage
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash; sudo rm /private/var/vm/sleepimage"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;

# Automatically list directory contents on `cd`.
# auto-ls () {
# 	emulate -L zsh;
# 	ls
# }
# chpwd_functions=( auto-ls $chpwd_functions )

# history mgmt
# http://www.refining-linux.org/archives/49/ZSH-Gem-15-Shared-history/
setopt inc_append_history
setopt share_history

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
