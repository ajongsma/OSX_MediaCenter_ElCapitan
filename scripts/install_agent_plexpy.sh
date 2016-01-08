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
    cp ../config/launchctl/local.plex.plexpy.plist /Library/LaunchDaemons/
    print_result $? 'Copy PlexPy launch agent'

    #ask_for_sudo
    #install_dmg "HOME/Downloads/${SABNZBD_DIR}-osx.dmg"
  fi

	print_result $? 'LaunchAgent PlexPy'
}

main