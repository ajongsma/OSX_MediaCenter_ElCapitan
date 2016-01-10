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
	if ! cmd_exists 'brew'; then
		print_error 'Homebrew required'
	fi

  #Let's do it
  if ! cmd_exists 'mysql'; then
    brew install homebrew/versions/mysql56

    ln -sfv /usr/local/opt/mysql56/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql56.plist

    mysql.server start

    mysql_secure_installation
  fi
  
	print_result $? 'MySQL 5.6'
}

main