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
  if [ "${SONARR_FOLDER}" == "" ] ; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  # Let's do it
  if ! folder_exists $SONARR_FOLDER; then

    if ! cmd_exists 'brew'; then
      print_error 'Homebrew required'
      exit 1
    fi

    if ! cmd_exists 'mono'; then
      print_error 'Mono required'
      exit 1
    fi

    sudo mkdir -p $SONARR_FOLDER
    sudo chown -R `whoami`:staff $SONARR_FOLDER

    ## Stable version
    git clone https://github.com/Sonarr/Sonarr.git $SONARR_FOLDER
    print_result $? 'Download Sonarr'

    #cp ../config/sonarr/config.properties $SONARR_FOLDER/
  fi

#  mono --debug ./opt/NzbDrone/NzbDrone.exe
#  open http://localhost:8989
#  echo " --- press any key to continue ---"
#  read -n 1 -s

  print_result $? 'Sonarr'
}

main
