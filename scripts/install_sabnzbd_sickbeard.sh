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
  if ! file_exists $SICKBEARD_FOLDER; then
    if ! folder_exists $SICKBEARD_FOLDER; then
      print_error "Sickbeard not detected"
      exit 1
    fi
    if ! folder_exists $SPOTWEB_FOLDER; then
      print_error "Spotwel not detected"
      exit 1
    fi


#  sudo cp /Applications/Sick-Beard/autoProcessTV/* ~/Library/Application\ Support/SABnzbd/scripts/ 

 #   if [ "${SICKBEARD_FOLDER}" == "" ] ; then
 #     echo "Error: Not all config setting have been found set, please check config.sh."
 #     exit 1
 #   fi
#
#    ask_for_sudo
#    sudo mkdir -p $SICKBEARD_FOLDER
#    sudo chown -R `whoami`:staff $SICKBEARD_FOLDER
#
#    git clone git://github.com/midgetspy/Sick-Beard.git $SICKBEARD_FOLDER
#    print_result $? 'Download Sickbeard'
  fi


#  cd $SICKBEARD_FOLDER
#  python SickBeard.py
#  #python sickbeard.py -d
# 
#  open http://localhost:8081/
#  echo " --- press any key to continue ---"
#  read -n 1 -s


  print_result $? 'Sickbeard'
}

main
