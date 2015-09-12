#!/bin/sh

CONFIG_URL_DEFAULT=https://github.com/rtfpessoa/dotfiles
CONFIG_DIR_NAME=".$(whoami)rc"
CONFIG_PATH_DEFAULT="$HOME"

while getopts ":c:u:d:af" opt; do
  case $opt in
    c)
      ARG_CMD="$OPTARG"
      ;;
    u)
      ARG_CONFIG_URL="$OPTARG"
      ;;
    d)
      ARG_DEST_DIR="$OPTARG"
      ;;
    a)
      ASK_VALUE="ask"
      ;;
    f)
      FORCE_INSTALL="force"
      ;;
    \?)
      echo "Invalid option -$OPTARG" >&2
      echo ""
      echo "usage: -c (install | update | uninstall) [options]"
      echo ""
      echo "options: "
      echo "  -a ask before execute each step "
      echo "  -u [<URL>] set the url for the origin repository to install"
      echo "  -d [<DEST DIR>] set the destination directory to install"
      echo "    IMPORTANT: if you change the default directory, you need to set"
      echo "               'DOTFILES_DIR' before the shell is loaded"
      echo "               ex: export DOTFILES_DIR=/Users/me/.merc"
      echo "  -f force the installation on update"
      echo ""
      exit 1
      ;;
  esac
done

# Args
CMD=${ARG_CMD-install}
CONFIG_URL=${ARG_CONFIG_URL-$CONFIG_URL_DEFAULT}
CONFIG_PATH=${ARG_DEST_DIR-$CONFIG_PATH_DEFAULT}

# Export dir for global access
DOTFILES_DIR_TMP="$CONFIG_PATH/$CONFIG_DIR_NAME"
export DOTFILES_DIR="${DOTFILES_DIR-$DOTFILES_DIR_TMP}"

if [ "$CMD" == "install" ]; then
  echo "Installing Unix configs"
  git clone --recursive $CONFIG_URL "$DOTFILES_DIR"

  cd "$DOTFILES_DIR"
  [ "$ASK_VALUE" = "ask" ] && export ASK="true"
  rake install
elif [ "$CMD" == "update" ]; then
  echo "Updating Unix configs"
  [ -d "$DOTFILES_DIR" ] && cd "$DOTFILES_DIR"
  git pull && \
    git submodule update --init --recursive && \
    git submodule update --init --remote --force --recursive --
  [ "$FORCE_INSTALL" = "force" ] && rake install
elif [ "$CMD" == "uninstall" ] || [ "$CMD" == "remove" ] || [ "$CMD" == "rm" ]; then
  $DOTFILES_DIR/uninstall.sh $DOTFILES_DIR
fi
