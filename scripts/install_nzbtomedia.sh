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
  if ! folder_exists $NZBTOMEDIA_FOLDER; then
    if [ "${NZBTOMEDIA_FOLDER}" == "" ] ; then
      echo "Error: Not all config setting have been found set, please check config.sh."
      exit 1
    fi

    ask_for_sudo
    sudo mkdir -p $NZBTOMEDIA_FOLDER
    sudo chown -R `whoami`:staff $NZBTOMEDIA_FOLDER

    git clone https://github.com/clinton-hall/nzbToMedia.git $NZBTOMEDIA_FOLDER
    print_result $? 'Download NzbToMedia'
  fi

  sudo ln -sf /usr/bin/python2.7 /usr/local/bin/python2

  print_result $? 'NzbToMedia'
}

main
