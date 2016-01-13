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
## https://forums.plex.tv/discussion/102818/rel-trakt
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
  ## Sanity check
  if [ "${PLEX_PMS_TRAKTTV}" == "" ]; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  ## Let's do it
  if ! folder_exists $PLEX_PMS_TRAKTTV; then
    ask_for_sudo
    sudo mkdir -p $PLEX_PMS_TRAKTTV
    sudo chown -R `whoami`:staff $PLEX_PMS_TRAKTTV

    git clone -b beta https://github.com/trakt/Plex-Trakt-Scrobbler.git $PLEX_PMS_TRAKTTV
    print_result $? 'Download PMS channel TraktTV'

    sudo ln -s $PLEX_PMS_TRAKTTV $HOME/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/TraktTV-beta.bundle
  fi

  print_result $? 'Plex PMS - TraktTV'
}

main
