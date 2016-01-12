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

  if ! cmd_exists 'curl'; then
    print_error 'Error: Not all config setting have been found set, please check config.sh'
    exit 1
  fi

  URL="http://localhost/spotweb/api?t=c"
  TMPFILE=`mktemp /tmp/spotweb.XXXXXX`
  curl -s -o ${TMPFILE} ${URL} 2>/dev/null
  if [ "$?" -ne "0" ]; then
    print_error 'Unable to connect to ${URL}'
    echo " --- press any key to continue ---"
    read -n 1 -s
    exit 2
  fi

  RES=`grep -i "Spotweb API Index" ${TMPFILE}`
  if [ "$?" -ne "0" ]; then
    print_error 'String Spotweb API Index not found in '${URL}
    print_error 'Copy the SpotWEB htaccess file and restart Apache'
    echo ' --- press any key to continue ---'
    read -n 1 -s
    exit 2
  else
    print_success 'String Spotweb API Index found in '$URL
  fi

  print_result $? 'Spotweb API test'
}

main
