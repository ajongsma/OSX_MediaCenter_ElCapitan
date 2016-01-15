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
  if [ "${AUTOSUB_FOLDER}" == "" ] ; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  # Let's do it
  if ! folder_exists $AUTOSUB_FOLDER; then
    sudo mkdir -p $AUTOSUB_FOLDER
    sudo chown -R `whoami`:staff $AUTOSUB_FOLDER

    ## Unstable version
    #git clone https://github.com/BenjV/autosub.git $AUTOSUB_FOLDER

    ## Stable version
    git clone https://github.com/clone1612/autosub-bootstrapbill.git $AUTOSUB_FOLDER
    print_result $? 'Download Autosub'

    #cp ../config/autosub/config.properties $AUTOSUB_FOLDER/
  fi

#  open http://localhost:8080
#  echo " --- press any key to continue ---"
#  read -n 1 -s

  print_result $? 'Spotweb'
}

main
