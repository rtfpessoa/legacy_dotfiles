#!/bin/sh

#
# OS X Shell Settings
#

# Force my HOME (sudo compatibility)
export_globally DEFAULT_USER "rtfpessoa"

# Want your terminal to support 256 color schemes? I do ...
export_globally TERM "xterm-256color"
export_globally CLICOLOR 1
export_globally OPERATING_SYSTEM "$(uname)"

# Languages
export_globally LANG "en_GB.UTF-8"
export_globally LC_COLLATE "en_GB.UTF-8"
export_globally LC_CTYPE "en_GB.UTF-8"
export_globally LC_MESSAGES "en_GB.UTF-8"
export_globally LC_MONETARY "en_GB.UTF-8"
export_globally LC_NUMERIC "en_GB.UTF-8"
export_globally LC_TIME "en_GB.UTF-8"
export_globally LC_ALL "en_GB.UTF-8"

# Editor
export_globally EDITOR "vim"
export_globally VISUAL "vim"
export_globally GREP_COLOR '1;33'

# export_globally GDK_SCALE 2
# export_globally QT_SCALE_FACTOR 1.2

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  export_globally HOME "/home/$DEFAULT_USER"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export_globally HOME "/Users/$DEFAULT_USER"
fi

# Visual Studio Code
# Since in Linux we are using snap we do not need any alias :)
if [[ "$OSTYPE" == "darwin"* ]]; then
  code() {
	local VSCODE_PATH "/Applications/Visual\ Studio\ Code.app/Contents"
	local ELECTRON "$VSCODE_PATH/MacOS/Electron"
	local CLI "$VSCODE_PATH/Resources/app/out/cli.js"
	ELECTRON_RUN_AS_NODE=1 "$ELECTRON" "$CLI" "$@"
  }
fi

# GO
if [[ "$OSTYPE" == "darwin"* ]]; then
  export_globally GOROOT "/usr/local/opt/go/libexec"
fi
export_globally GOPATH $HOME/.go
add_to_path "$GOPATH/bin"

add_to_path "/usr/local/sbin"
add_to_path "/usr/local/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  add_to_path "/usr/local/opt/coreutils/libexec/gnubin"
  export_globally MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# Node
if test -s "$HOME/.nodenv"; then
	add_to_path "$HOME/.nodenv/bin"
	add_to_path "$HOME/.nodenv/shims"
	eval "$($HOME/.nodenv/bin/nodenv init - --no-rehash $SHELL)"
fi

if which yarn 2>&1 >/dev/null; then
	add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
fi

# Ruby
if test -s "$HOME/.rbenv"; then
	add_to_path "$HOME/.rbenv/bin"
	add_to_path "$HOME/.rbenv/shims"
	eval "$($HOME/.rbenv/bin/rbenv init - --no-rehash $SHELL)"
fi

# Python
add_to_path "/usr/local/opt/python@2/bin"
if test -s "$HOME/.pyenv/bin/pyenv"; then
	export_globally PYENV_ROOT "$HOME/.pyenv"
	add_to_path "$PYENV_ROOT/bin"
	eval "$($HOME/.pyenv/bin/pyenv init - --no-rehash $SHELL)"
fi

# Java
if test -s "$HOME/.jabba/jabba.sh"; then
	source "$HOME/.jabba/jabba.sh"
fi

# krypt.co
export_globally GPG_TTY $(tty)

# Rust
add_to_path "$HOME/.cargo/bin"
