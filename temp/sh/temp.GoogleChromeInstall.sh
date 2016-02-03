#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	GoogleChromeInstall.sh -- Installs the latest Google Chrome version
#
# SYNOPSIS
#	sudo GoogleChromeInstall.sh
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Joe Farage, 17.03.2015
#
####################################################################################################
# Script to download and install Google Earth.
# Only works on Intel systems.

dmgfile="googlechrome.dmg"
volname="Google Chrome"
logfile="GoogleChromeInstallScript.log"

url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
		/bin/echo "--"
		/bin/echo "`date`: Downloading latest version."
		/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
		/bin/echo "`date`: Mounting installer disk image."
		/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse #-quiet
		/bin/echo "`date`: Installing..."
		ditto -rsrc "/Volumes/${volname}/Google Chrome.app" "/Applications/Google Chrome.app"
		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image."
		/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') #-quiet
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image."
		/bin/rm /tmp/"${dmgfile}"
else
	/bin/echo "`date`: ERROR: This script is for Intel Macs only."
fi

exit 0