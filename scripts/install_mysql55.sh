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
  if ! cmd_exists 'mysql'; then
    # Sanity check
    if ! cmd_exists 'brew'; then
      print_error 'Homebrew required'
      exit
    fi
    brew install homebrew/versions/mysql55

    ln -sfv /usr/local/opt/mysql55/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql55.plist

    mysql.server start

    mysql_secure_installation

    ## brew unlink mysql57
    ## brew switch mysql 5.5
    ## brew unlink mysql && brew link mysql55 --force
  fi
  
	print_result $? 'MySQL 5.5'
}

main