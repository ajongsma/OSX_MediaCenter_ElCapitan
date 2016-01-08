#!/bin/bash

## Initializing
if [ -f _functions.sh ]; then
   echo "Loading functions file (1)"
   source _functions.sh
elif [ -f ../_functions.sh ]; then
    echo "Loading functions file (2)"
    source ../_functions.sh
else
   echo "Config file functions.sh does not exist"
fi

if [ -f config.sh ]; then
   echo "Loading config file (1)"
   source config.sh
elif [ -f ../config.sh ]; then
	echo "Loading config file (2)"
	source ../config.sh
else
   echo "Config file config.sh does not exist"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {
	if ! file_exist '/Library/LaunchDaemons/local.plex.plexpy.plist'; then
    SABNZBD_VERSION=`curl -s http://sabnzbdplus.sourceforge.net/version/latest | head -n1`
    SABNZBD_DIR="SABnzbd-${SABNZBD_VERSION}"
    SABNZBD_GZ="${SABNZBD_DIR}-osx.dmg"

    download "http://freefr.dl.sourceforge.net/project/sabnzbdplus/sabnzbdplus/${SABNZBD_VERSION}/${SABNZBD_GZ}" "$HOME/Downloads/${SABNZBD_DIR}-osx.dmg"
    print_result $? 'Download SabNZBD'

    ask_for_sudo
    install_dmg "HOME/Downloads/${SABNZBD_DIR}-osx.dmg"
  fi

	print_result $? 'Homebrew'
}

main