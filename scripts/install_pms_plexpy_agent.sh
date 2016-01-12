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
	if ! file_exists '/Library/LaunchAgents/local.plex.plexpy.plist'; then
    ask_for_sudo
    sudo cp ../config/launchctl/local.plex.plexpy.plist /Library/LaunchAgents/local.plex.plexpy.plist
    #print_result $? 'Copy PlexPy launch agent'

    sudo chown root:wheel /Library/LaunchAgents/local.plex.plexpy.plist
    sudo chmod 644 /Library/LaunchAgents/local.plex.plexpy.plist

    launchctl load /Library/LaunchAgents/local.plex.plexpy.plist
  fi

	print_result $? 'LaunchAgent PlexPy'
}

main