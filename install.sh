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

# Setting some color constants
COLOR_GREEN="\x1b[0;32m"
COLOR_RED="\x1b[0;31m"
COLOR_RESET="\x1b[0m"

# Setting some escaped characters
CHAR_CHECKMARK="\xE2\x9C\x93"
CHAR_XMARK="\xE2\x9C\x97"

# Host used to test Internet connection
PING_HOST="www.google.com"




## ----------------------------------------------------------------------------
## Functions
abort() {
  echo "$1"
  exit 1
}

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
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
sw_build=$(sw_vers -buildVersion)

echo
echo "Checking a few things to make sure we are good to go..."
echo

# Checking for an Internet connection
if /sbin/ping -s1 -t4 -o ${PING_HOST} >/dev/null 2>&1
  then
    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} We have an Internet connection."
  else
    abort "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} We do not have an Internet connection."
fi

# Check if the current account is in the admin group
if groups | grep -w -q admin 2>&1
  then
    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} You are an admin."
  else
    abort "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} You are not an admin."
fi

# Determine if the Xcode command line tools installed.

# Checking to make sure xcode-command line tools are installed.
XCODE_SELECT=$(xcode-select -p 2>&1);
#if [[ $XCODE_SELECT == "/Library/Developer/CommandLineTools" || \
#  $XCODE_SELECT == "/Applications/Xcode.app/Contents/Developer" ]]
if [ "$XCODE_SELECT" = '/Library/Developer/CommandLineTools' ] || \
    [ "$XCODE_SELECT" = '/Applications/Xcode.app/Contents/Developer' ]
  then
    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} Xcode command line tools installed."
  else
    echo "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} Xcode command line tools not installed."
    abort "Please run '$ xcode-select --install'"
fi

# Checking for git
if command -v /usr/bin/git >/dev/null 2>&1
  then
    echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} git appears to be available."
  else
    abort "${COLOR_RED}${CHAR_XMARK}${COLOR_RESET} Xcode command line tools git not found!"
fi
echo
echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} All good to go..."
echo

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
if [[ $ENABLE_LIBRARY_VIEW == "true" ]]; then
    source "$DIR/scripts/osx_libraryview_enable.sh"
fi

#------------------------------------------------------------------------------
# Enable Tap to Click for this user and for the login screen
#------------------------------------------------------------------------------
if [[ $ENABLE_MOUSE_TAPTOCLICK == "true" ]]; then
    source "$DIR/scripts/osx_mouse_taptoclick_enable.sh"
fi

