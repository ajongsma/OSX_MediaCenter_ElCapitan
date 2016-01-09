#!/bin/bash

## Initializing
if [ -f _functions.sh ]; then
  source _functions.sh
elif [ -f ../_functions.sh ]; then
  source ../_functions.sh
else
  echo "Config file functions.sh does not exist"
fi

if [ -f config.sh ]; then
  source config.sh
elif [ -f ../config.sh ]; then
  source ../config.sh
  exit 1
else
  echo "Config file config.sh does not exist"
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
declare -a DIRECTORIES=(
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