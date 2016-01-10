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
  if ! folder_exists $COUCHPOTATO_FOLDER; then
    if [ "${COUCHPOTATO_FOLDER}" == "" ] ; then
      echo "Error: Not all config setting have been found set, please check config.sh."
      exit 1
    fi
    sudo mkdir -p $COUCHPOTATO_FOLDER
    sudo chown -R `whoami`:staff $COUCHPOTATO_FOLDER

    git clone https://github.com/RuudBurger/CouchPotatoServer.git $COUCHPOTATO_FOLDER
    print_result $? 'Download Couch Potato'
  fi



#  open http://localhost:5050/
#  echo " --- press any key to continue ---"
#  read -n 1 -s


  print_result $? 'CouchPotato'
}

main
