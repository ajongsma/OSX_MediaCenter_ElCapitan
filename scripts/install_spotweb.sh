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
  if ! folder_exists $SPOTWEB_FOLDER; then
    sudo mkdir -p $SPOTWEB_FOLDER
    sudo chown `whoami`:staff $SPOTWEB_FOLDER

    git clone https://github.com/spotweb/spotweb.git Spotweb
    print_result $? 'Download Spotweb'


  fi

  print_result $? 'Spotweb'
}

main
