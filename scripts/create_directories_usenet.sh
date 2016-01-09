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
declare -a DIRECTORIES=(
    "$HOME/Usenet"
    "$HOME/Usenet/Completed"
    "$HOME/Usenet/Incomplete"
)

main() {
    for i in ${DIRECTORIES[@]}; do
        mkd "$i"
    done
}

main