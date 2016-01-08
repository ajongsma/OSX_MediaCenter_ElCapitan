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
set_preferences() {
    execute 'defaults write com.apple.dashboard mcx-disabled -bool true' \
        'Disable Dashboard'
}

main() {
    print_in_purple '\n  Dashboard\n\n'
    set_preferences

    # 'killall Dashboard' doesn't actually do anything. To apply
    # the changes for Dashboard, 'killall Dock' is enough as Dock
    # is Dashboard's parent process.

    killall 'Dock' &> /dev/null
}

main