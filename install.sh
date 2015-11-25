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

SOURCE="${BASH_SOURCE[0]}"
DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ ! -f config.sh ]; then
  clear
  echo "No config.sh found. Creating file, and please edit the required values"
  cp config.sh.default config.sh
  vi config.sh
fi

source config.sh

if [[ $AGREED == "no" ]]; then
  echo "Please edit the config.sh file"
  exit
fi

## ----------------------------------------------------------------------------
DEBUG=0

PRINTF_MASK="%-50s %s %10s %s\n"
TIMESTAMP=`date +%Y%m%d%H%M%S`

## ----------------------------------------------------------------------------
## Functions

function to_lower()
{
    echo $1 | tr '[A-Z]' '[a-z]'
}

function check_system() {
    # Check for supported system
    kernel=`uname -s`
    case $kernel in
        Darwin) ;;
        *) fail "Sorry, $kernel is not supported." ;;
    esac
}

## ----------------------------------------------------------------------------
## Main
check_system

#------------------------------------------------------------------------------
# Keep-alive: update existing sudo time stamp until finished
#------------------------------------------------------------------------------
# Ask for the administrator password upfront
echo "--------------------------------------"
echo "| Please enter the root password     |"
echo "--------------------------------------"
sudo -v
echo "--------------------------------------"

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#------------------------------------------------------------------------------
# Checking if system is up-to-date
#------------------------------------------------------------------------------
## Run software update and reboot
if [[ $INST_OSX_UPDATES == "true" ]]; then
    sudo softwareupdate --list
    sudo softwareupdate --install --all
fi

#------------------------------------------------------------------------------
# Show the ~/Library folder
#------------------------------------------------------------------------------
chflags nohidden ~/Library

#------------------------------------------------------------------------------
# Enable Tap to Click for this user and for the login screen
#------------------------------------------------------------------------------
if [[ $ENABLE_MOUSE_TAPTOCLICK == "true" ]]; then
    source "$DIR/scripts/osx_mouse_taptoclick_enable.sh"
fi

