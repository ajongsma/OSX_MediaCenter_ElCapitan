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
  if ! cmd_exists 'mysql'; then
    if ! cmd_exists 'brew'; then
      print_error 'Homebrew required'
      exit;
    fi

    brew install mysql
    unset TMPDIR
    
    ## mysql_install_db: [ERROR] unknown variable 'tmpdir=/tmp'
    #mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
    
    mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql

    ask_for_sudo
    sudo ln -sfv /usr/local/opt/mysql/*.plist /Library/LaunchAgents
    sudo launchctl load /Library/LaunchAgents/homebrew.mxcl.mysql.plist

    /usr/local/Cellar/mysql/5.7.10/bin/mysql_secure_installation

    sudo mkdir /var/mysql
    sudo ln -s /private/tmp/mysql.sock /var/mysql/mysql.sock

    mysql.server start
  fi

  print_result $? 'MySQL'
}

main