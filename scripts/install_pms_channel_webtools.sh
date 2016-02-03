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

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## https://forums.plex.tv/discussion/126254/rel-webtools
## https://github.com/dagalufh/WebTools.bundle
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
  ## Sanity check
  if [ "${PLEX_PMS_WEBTOOLS}" == "" ]; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  ## Let's do it
  if ! folder_exists $PLEX_PMS_WEBTOOLS; then
    ask_for_sudo
    sudo mkdir -p $PLEX_PMS_WEBTOOLS
    sudo chown -R `whoami`:staff $PLEX_PMS_WEBTOOLS

    git clone https://github.com/dagalufh/WebTools.bundle.git $PLEX_PMS_WEBTOOLS
    print_result $? 'Download PMS channel WebTools'

    ln -s $PLEX_PMS_WEBTOOLS/Trakttv.bundle $HOME/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/WebTools.bundle
  fi

  print_result $? 'Plex PMS - WebTools'
}

main
