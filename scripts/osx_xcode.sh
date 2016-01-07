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

    if ! xcode-select --print-path &> /dev/null; then

        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        print_result $? 'Install XCode Command Line Tools'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        print_result $? 'Make "xcode-select" developer directory point to Xcode'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10

        sudo xcodebuild -license
        print_result $? 'Agree with the XCode Command Line Tools licence'

    fi

    print_result $? 'XCode Command Line Tools'

}

main