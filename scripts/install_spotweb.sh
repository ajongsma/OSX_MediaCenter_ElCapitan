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
  # Sanity check
  if [ "${SPOTWEB_FOLDER}" == "" ]; then
    echo "Error: Need username & password to download PlexPass version. Otherwise run with -p to download public version."
    exit 1
  fi

  # Let's do it
  if ! folder_exists $SPOTWEB_FOLDER; then
    sudo mkdir -p $SPOTWEB_FOLDER
    sudo chown `whoami`:staff $SPOTWEB_FOLDER

    git clone https://github.com/spotweb/spotweb.git $SPOTWEB_FOLDER
    print_result $? 'Download Spotweb'

    sudo ln -s $SPOTWEB_FOLDER /Library/Server/Web/Data/Sites/Default/spotweb



    open http://localhost/spotweb/install.php
    echo " --- press any key to continue ---"
    read -n 1 -s

    ## PHP extension: gettext           - Not OK
    ## GD           : FreeType Support  - Not OK
    ## Cache directory is writable?     - Not OK
    ## Own settings file                - NOT OK (optional)



if ! mysql_db_exist 'ssspotweb'; then
  echo "22"
  print_error 'file not found'
exit;
fi




# /Library/Server/Web/Config/apache2/webapps/


# ps aux | grep httpd

# cat /Library/Server/Web/Config/apache2/httpd_server_app.conf
#  Include /Library/Server/Web/Config/apache2/sites/*.conf



# http://pablin.org/2015/04/30/configuring-jenkins-on-os-x-server/

# http://mar2zz.tweakblogs.net/blog/6724/spotweb-als-provider.html
# http://www.happylark.nl/spotweb-instellen/

  fi


  print_result $? 'Spotweb'
}

main
