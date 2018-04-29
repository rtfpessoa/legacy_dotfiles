#!/usr/bin/env bash

CLONE_URL_DEFAULT=https://github.com/rtfpessoa/dotfiles
DOTFILES_NAME=".$(whoami)rc"
DOTFILES_PATH="$HOME"
BRANCH="master"

help() {
  echo "Invalid option -$OPTARG" >&2
  echo ""
  echo "usage: -c (install | update | uninstall) [options]"
  echo ""
  echo "options: "
  echo "  -a ask before execute each step"
  echo "  -u [<URL>] set the url for the origin repository to install"
  echo "  -d [<DEST_PATH>] set the destination directory to install"
  echo "    IMPORTANT: if you change the default directory, you need to set"
  echo "               'DOTFILES' before the shell is loaded"
  echo "               ex: export DOTFILES=/Users/me/.merc"
  echo "  -f force the installation on update"
  echo ""
  exit 1
}

while getopts ":c:u:d:af" opt; do
  case $opt in
    b)
      BRANCH="$OPTARG"
      ;;
    c)
      CMD="$OPTARG"
      ;;
    u)
      ARG_CLONE_URL="$OPTARG"
      ;;
    d)
      ARG_DEST_PATH="$OPTARG"
      ;;
    a)
      ASK_VALUE="ask"
      ;;
    f)
      FORCE_INSTALL="force"
      ;;
    \?)
      help
      ;;
  esac
done

# Command is mandatory
[[ -z $ARG_CMD ]] || help

# Args
CLONE_URL=${ARG_CLONE_URL-$CLONE_URL_DEFAULT}
CONFIG_PATH=${ARG_DEST_PATH-$DOTFILES_PATH}

# Export dir for global access
DOTFILES_OVERRIDE="$CONFIG_PATH/$DOTFILES_NAME"
export DOTFILES="${DOTFILES_OVERRIDE-$DOTFILES}"

[[ "$ASK_VALUE" == "ask" ]] && export ASK="true"

case $CMD in
  install)
    echo "Installing Unix configs"
    [[ ! -d "$DOTFILES" ]] && git clone -b ${BRANCH} --recursive $CLONE_URL "$DOTFILES"
    cd "$DOTFILES"
    rake install
    ;;

  update)
    echo "Updating Unix configs"
    [[ -d "$DOTFILES" ]] && cd "$DOTFILES"
    rake update
    ;;

  uninstall)
    [[ -d "$DOTFILES" ]] && cd "$DOTFILES"
    ./uninstall.sh
    ;;

  *)
    help
    ;;
esac
