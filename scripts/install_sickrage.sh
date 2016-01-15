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
  if ! folder_exists $SICKRAGE_FOLDER; then
    if [ "${SICKRAGE_FOLDER}" == "" ] ; then
      echo "Error: Not all config setting have been found set, please check config.sh."
      exit 1
    fi

    ask_for_sudo
    sudo mkdir -p $SICKRAGE_FOLDER
    sudo chown -R `whoami`:staff $SICKRAGE_FOLDER

    git clone https://github.com/SiCKRAGETV/SickRage.git $SICKRAGE_FOLDER
    print_result $? 'Download SickRage'
  fi


#  cd $SICKRAGE_FOLDER
#  python SickBeard.py
#  #python sickbeard.py -d
# 
#  open http://localhost:8081/
#  echo " --- press any key to continue ---"
#  read -n 1 -s


  print_result $? 'Sickbeard'
}

main
