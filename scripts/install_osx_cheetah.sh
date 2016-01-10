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
  ## Sanity check
	if ! cmd_exists 'pip'; then
		print_error 'pip required'
	fi

  ## Let's do it
  if ! cmd_exists 'cheetah'; then
    ask_for_sudo
    sudo -H pip install cheetah
  fi

  

	print_result $? 'cheetah'
}

main