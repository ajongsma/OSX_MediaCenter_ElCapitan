#!/bin/bash

## https://github.com/mrworf/plexupdate/blob/master/plexupdate.sh

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
KEEP=no

# Current pages we need - Do not change unless Plex.tv changes again
PLEX_URL_LOGIN=https://plex.tv/users/sign_in
PLEX_URL_DOWNLOAD=https://plex.tv/downloads?channel=plexpass
PLEX_URL_DOWNLOAD_PUBLIC=https://plex.tv/downloads


# If user wants, we skip authentication, but only if previous auth exists
if [ "${KEEP}" != "yes" -o ! -f /tmp/kaka ] && [ "${PUBLIC}" == "no" ]; then
	echo -n "Authenticating..."
	# Clean old session
	rm /tmp/kaka 2>/dev/null

	# Get initial seed we need to authenticate
	SEED=$(wget --save-cookies /tmp/kaka --keep-session-cookies ${URL_LOGIN} -O - 2>/dev/null | grep 'name="authenticity_token"' | sed 's/.*value=.\([^"]*\).*/\1/')
	if [ $? -ne 0 -o "${SEED}" == "" ]; then
		echo "Error: Unable to obtain authentication token, page changed?"
		exit 1
	fi

	# Build post data
	echo -ne  >/tmp/postdata  "$(keypair "utf8" "&#x2713;" )"
	echo -ne >>/tmp/postdata "&$(keypair "authenticity_token" "${SEED}" )"
	echo -ne >>/tmp/postdata "&$(keypair "user[login]" "${EMAIL}" )"
	echo -ne >>/tmp/postdata "&$(keypair "user[password]" "${PASS}" )"
	echo -ne >>/tmp/postdata "&$(keypair "user[remember_me]" "0" )"
	echo -ne >>/tmp/postdata "&$(keypair "commit" "Sign in" )"

	# Authenticate
	wget --load-cookies /tmp/kaka --save-cookies /tmp/kaka --keep-session-cookies "${URL_LOGIN}" --post-file=/tmp/postdata -O /tmp/raw 2>/dev/null 
	if [ $? -ne 0 ]; then
		echo "Error: Unable to authenticate"
		exit 1
	fi
	# Delete authentication data ... Bad idea to let that stick around
	rm /tmp/postdata

	# Provide some details to the end user
	if [ "$(cat /tmp/raw | grep 'Sign In</title')" != "" ]; then
		echo "Error: Username and/or password incorrect"
		exit 1
	fi
	echo "OK"
else
	# It's a public version, so change URL and make doubly sure that cookies are empty
	rm 2>/dev/null >/dev/null /tmp/kaka
	touch /tmp/kaka
	URL_DOWNLOAD=${URL_DOWNLOAD_PUBLIC}
fi

