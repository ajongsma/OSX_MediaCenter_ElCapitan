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
	if ! folder_exists "$FOLDER_INSTALL/Server.app"; then
    if file_exists "$FOLDER_INSTALL/OS X Server 5.0.15.dmg"; then
      ask_for_sudo
      install_dmg "HOME/Downloads/${SABNZBD_DIR}-osx.dmg"
    else
      if folder_exists "$FOLDER_INSTALL/Server.app"; then
        ask_for_sudo
        cp -R "$FOLDER_INSTALL/Server.app" "/Applications/Server.app" 
      else
        print_error 'OS X Server App file NOT found in "$FOLDER_INSTALL"!\n'
        exit 1
      fi
    fi    
	fi
	print_result $? 'OS X Server'
}

main