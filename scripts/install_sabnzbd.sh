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
  if ! folder_exists '/Applications/SABnzbd.app/'; then
    SABNZBD_VERSION=`curl -s http://sabnzbdplus.sourceforge.net/version/latest | head -n1`
    SABNZBD_DIR="SABnzbd-${SABNZBD_VERSION}"
    SABNZBD_GZ="${SABNZBD_DIR}-osx.dmg"

    download "http://freefr.dl.sourceforge.net/project/sabnzbdplus/sabnzbdplus/${SABNZBD_VERSION}/${SABNZBD_GZ}" "$FOLDER_DOWNLOAD/${SABNZBD_DIR}-osx.dmg"
    print_result $? 'Download SabNZBD'

    ask_for_sudo
    install_dmg "$FOLDER_DOWNLOAD/${SABNZBD_DIR}-osx.dmg"
  fi

  print_result $? 'SabNZBD'
}

main
