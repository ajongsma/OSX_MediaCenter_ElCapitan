#!/bin/bash

## Initializing
if [ -f _functions.sh ]; then
   echo "Loading functions file (1)"
   source _functions.sh
elif [ -f ../_functions.sh ]; then
    echo "Loading functions file (2)"
    source ../_functions.sh
else
   echo "Config file functions.sh does not exist"
fi

if [ -f config.sh ]; then
  echo "Loading config file (1)"
  source config.sh
elif [ -f ../config.sh ]; then
  echo "Loading config file (2)"
  source ../config.sh
else
   echo "Config file config.sh does not exist"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
declare -a DIRECTORIES=(
    "$HOME/Torrents"
    "$HOME/Usenet"
    "$HOME/Usenet Completed"
    "$HOME/Media"
    "$HOME/Media/Documentary"
    "$HOME/Media/Movies"
    "$HOME/Media/Series"
)

main() {
    for i in ${DIRECTORIES[@]}; do
        mkd "$i"
    done
}

main