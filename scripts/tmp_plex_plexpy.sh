#!/bin/bash

## https://github.com/drzoidberg33/plexpy

## Initializing
if [ -f config.sh ]; then
   echo "Loading config file (1)"
   source config.sh
elif [ -f ../config.sh ]; then
	echo "Loading config file (2)"
	source ../config.sh
else
   echo "Config file config.sh does not exist"
fi

if [ -z "${BASH_VERSINFO}" ]; then
  echo "ERROR: You must execute this script with BASH"
  exit 255
fi

# Sanity check
if [ "${EMAIL}" == "" -o "${PASS}" == "" ] && [ "${PUBLIC}" == "false" ]; then
	echo "Error: Need username & password to download PlexPass version. Otherwise run with -p to download public version."
	exit 1
fi

# Remove any ~ or other oddness in the path we're given
echo "checking dowload folder: $FOLDER_DOWNLOAD"
FOLDER_DOWNLOAD="$(eval cd ${FOLDER_DOWNLOAD// /\\ } ; if [ $? -eq 0 ]; then pwd; fi)"
if [ -z "${FOLDER_DOWNLOAD}" ]; then
	echo "Error: Download directory does not exist or is not a directory"
	exit 1
fi

#################################################################
# Don't change anything below this point
#

if [ ! -d $PLEXPY_FOLDER ] ; then
  echo "${COLOR_YELLOW}${CHAR_XMARK}${COLOR_RESET} $PLEXPY_FOLDER doesn't exists, creating ..."
  sudo mkdir -p $PLEXPY_FOLDER
  sudo chown `whoami`:staff $PLEXPY_FOLDER
else
  echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} Folder PLEXPY_FOLDER exists."
fi

git clone https://github.com/drzoidberg33/plexpy.git PlyPy 

if [ ! -d "$HOME/Library/LaunchAgents" ] ; then
  echo "${COLOR_YELLOW}${CHAR_XMARK}${COLOR_RESET} $PLEXPY_FOLDER doesn't exists, creating ..."
  sudo mkdir -p "$HOME/Library/LaunchAgents"
else
  echo "${COLOR_GREEN}${CHAR_CHECKMARK}${COLOR_RESET} Library folder LaunchAgents exists."
fi

# /Library/LaunchDaemons

#[ -a .pow ] || ln -s "$POW_ROOT/Hosts" .pow

#cd $DIR