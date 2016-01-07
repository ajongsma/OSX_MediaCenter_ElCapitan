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

main() {
	if ! cmd_exists 'brew'; then
		printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
		#  └─ simulate the ENTER keypress
	fi

	print_result $? 'Homebrew'
}

main