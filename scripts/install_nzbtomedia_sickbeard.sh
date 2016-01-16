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
  if [ "${NZBTOMEDIA_FOLDER}" == "" ]; then
      echo "Error: Not all config setting have been found set, please check config.sh."
      exit 1
    fi

  if ! folder_exists $NZBTOMEDIA_FOLDER; then
    print_error 'Error: Folder not detected - '$NZBTOMEDIA_FOLDER
    exit 1
  fi

  if ! folder_exists '/Applications/SABnzbd.app/'; then
    print_error 'Error: Application not detected - SABnzbd'
    exit 1
  fi

  if ! file_exists $NZBTOMEDIA_FOLDER'/autoProcessMedia.cfg'; then
    cp $NZBTOMEDIA_FOLDER'/autoProcessMedia.cfg.spec' $NZBTOMEDIA_FOLDER'/autoProcessMedia.cfg'

  fi

  

  print_result $? 'NzbToMedia for SickBeard'
}

main
