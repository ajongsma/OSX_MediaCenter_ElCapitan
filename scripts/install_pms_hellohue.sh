#!/bin/bash

## Initializing
if [ -f _functions.sh ]; then
  source _functions.sh
elif [ -f ../_functions.sh ]; then
  source ../_functions.sh
else
   echo "Config file functions.sh does not exist"
   exit 1
fi

if [ -f config.sh ]; then
  source config.sh
elif [ -f ../config.sh ]; then
  source ../config.sh
else
  echo "Config file config.sh does not exist"
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {
  # Sanity check
  if [ "${PLEX_PMS_HELLOHUE}" == "" ]; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  if ! folder_exists $PLEX_PMS_HELLOHUE; then
    ask_for_sudo
    sudo mkdir -p $PLEX_PMS_HELLOHUE
    sudo chown -R `whoami`:staff $PLEX_PMS_HELLOHUE

    git clone https://github.com/ledge74/HelloHue.git $PLEX_PMS_HELLOHUE
    print_result $? 'Download PMS channel HelloHue'

    sudo ln -s $PLEX_PMS_HELLOHUE $HOME/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/HelloHue.bundle
  fi

  print_result $? 'Plex PMS - HelloHue'
}

main
