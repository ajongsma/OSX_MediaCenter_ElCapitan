#!/usr/bin/env bash

######## PLAY TIME ##############
### Exit the script if any statement returns a non-true return value.
#set -o errexit
##set -e
#
### Check for uninitialised variables
##set -o nounset
#
######## PLAY TIME - END ########



## ----------------------------------------------------------------------------
DEBUG=0

PRINTF_MASK="%-50s %s %10s %s\n"
TIMESTAMP=`date +%Y%m%d%H%M%S`

# Setting some color constants
COLOR_GREEN=$'\x1b[0;32m'
COLOR_RED=$'\x1b[0;31m'
COLOR_RESET=$'\x1b[0m'
BLUE=$'\x1b[0;34m'

# Setting some escaped characters
CHAR_CHECKMARK=$'\xE2\x9C\x93'
CHAR_XMARK=$'\xE2\x9C\x97'




## ----------------------------------------------------------------------------
## Main

if [ -f _functions.sh ]; then
  source _functions.sh
elif [ -f scripts/_functions.sh ]; then
  source scripts/_functions.sh
else
   echo "Config file functions.sh does not exist"
   exit 1
fi

echo
echo "Checking a few things to make sure we are good to go..."
echo

verify_os

if [ ! -f config.sh ]; then
  clear
  echo "No config.sh found. Creating file, please edit the required values"
  cp config.sh.default config.sh
  pico config.sh
fi

source config.sh

if [[ $AGREED == "no" ]]; then
  echo "Please edit the config.sh file"
  exit
fi

# Check if the current account is in the admin group
if groups | grep -w -q admin 2>&1
  then
    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} You are an admin."
  else
    abort "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} You are not an admin."
fi


#  # Checking for an Internet connection
#  if /sbin/ping -s1 -t4 -o ${PING_HOST} >/dev/null 2>&1
#    then
#      echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} We have an Internet connection."
#    else
#      abort "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} We do not have an Internet connection."
#  fi

#------------------------------------------------------------------------------
# Keep-alive: update existing sudo time stamp until finished
#------------------------------------------------------------------------------
# Ask for the administrator password upfront
#  echo "--------------------------------------"
#  echo "| Please enter the root password     |"
#  echo "--------------------------------------"
#  sudo -v
#  echo "--------------------------------------"
#
#  # Keep-alive: update existing `sudo` time stamp until finished
#  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#------------------------------------------------------------------------------
# Checking if system is up-to-date
#------------------------------------------------------------------------------
## Run software update and reboot
#  if [[ $INST_OSX_UPDATES == "true" ]]; then
#      echo "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} System is not up-to-date, updating ..."
#      sudo softwareupdate --list
#      sudo softwareupdate --install --all
#  else
#    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} System is up-to-date."
#  fi

#------------------------------------------------------------------------------
# Changing default system behaviour
#------------------------------------------------------------------------------
#  if [[ $ENABLE_LIBRARY_VIEW == "true" ]]; then
#      source "$DIR/scripts/osx_libraryview_enable.sh"
#  fi
#  if [[ $ENABLE_MOUSE_TAPTOCLICK == "true" ]]; then
#      source "$DIR/scripts/osx_mouse_taptoclick_enable.sh"
#  fi

