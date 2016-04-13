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
	if ! file_exists '/Users/Plex/PlexEmail/scripts/plexEmail.py'; then
    ask_for_sudo
    
    sudo easy_install requests
    
    cd /Users/Plex
    git clone https://github.com/jakewaldron/PlexEmail.git
    nano PlexEmail/scripts/config.conf
  
    # python plexEmail.py -t
  fi

  print_result $? 'Plex E-mail'
}

main
