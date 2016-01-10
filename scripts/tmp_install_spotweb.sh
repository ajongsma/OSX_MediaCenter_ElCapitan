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
  if [ "${SPOTWEB_FOLDER}" == "" ] || [ "${SPOTWEB_MYSQL_DB}" == "" ] || [ "${MYSQL_ROOT_UID}" == "" ] || [ "${SPOTWEB_MYSQL_PW}" == "" ] || [ "${MYSQL_ROOT_UID}" == "" ] || [ "${MYSQL_ROOT_PW}" == "" ] ; then
    echo "Error: Not all config setting have been found set, please check config.sh."
    exit 1
  fi

  # Let's do it
  if ! folder_exists $SPOTWEB_FOLDER; then
    sudo mkdir -p $SPOTWEB_FOLDER
    sudo chown -R `whoami`:staff $SPOTWEB_FOLDER

    git clone https://github.com/spotweb/spotweb.git $SPOTWEB_FOLDER
    print_result $? 'Download Spotweb'

    sudo ln -s $SPOTWEB_FOLDER /Library/Server/Web/Data/Sites/Default/spotweb

  fi

  if [ -z "`mysql_config_editor print --login-path=$MYSQL_ROOT_UID`" ]; then
    mysql_config_login_add 'localhost' $MYSQL_ROOT_UID $MYSQL_ROOT_PW
    print_result $? 'Stored MySQL authentication credential of '"$MYSQL_ROOT_UID"' to localhost'
  fi


  if ! mysql_db_exist $SPOTWEB_MYSQL_DB $MYSQL_ROOT_UID $MYSQL_ROOT_PW; then
    print_error 'DB not found'

    mysql --login-path=root -e "CREATE DATABASE $SPOTWEB_MYSQL_DB;"
    print_result $? 'Created MySQL database $SPOTWEB_MYSQL_DB'
    
    mysql --login-path=root -e "CREATE USER $SPOTWEB_MYSQL_UID@'localhost' IDENTIFIED BY '$SPOTWEB_MYSQL_PW';"
    print_result $? 'Created user $SPOTWEB_MYSQL_UID in the MySQL database $SPOTWEB_MYSQL_DB'

    mysql --login-path=root -e "GRANT ALL PRIVILEGES ON $SPOTWEB_MYSQL_DB.* TO $SPOTWEB_MYSQL_UID@'localhost' IDENTIFIED BY '$SPOTWEB_MYSQL_PW';"
    print_result $? 'Granted access of user $SPOTWEB_MYSQL_UID to the MySQL database $SPOTWEB_MYSQL_DB'
  fi


  open http://localhost/spotweb/install.php
  echo " --- press any key to continue ---"
  read -n 1 -s

  ## PHP extension: gettext           - Not OK
  ## GD           : FreeType Support  - Not OK
  ## Cache directory is writable?     - Not OK
  ## Own settings file                - NOT OK (optional)






# /Library/Server/Web/Config/apache2/webapps/


# ps aux | grep httpd

# cat /Library/Server/Web/Config/apache2/httpd_server_app.conf
#  Include /Library/Server/Web/Config/apache2/sites/*.conf


# http://synology.brickman.nl/syn_howto/HowTo%20-%20install%20Spotweb.txt

# http://pablin.org/2015/04/30/configuring-jenkins-on-os-x-server/

# http://mar2zz.tweakblogs.net/blog/6724/spotweb-als-provider.html
# http://www.happylark.nl/spotweb-instellen/

  




exit

  print_result $? 'Spotweb'
}

main
