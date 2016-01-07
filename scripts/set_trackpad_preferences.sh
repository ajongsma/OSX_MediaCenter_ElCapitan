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

    execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true &&
             defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 &&
             defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1' \
        'Enable "Tap to click"'

    execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true &&
             defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true &&
             defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0 &&
             defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0' \
        'Map "click or tap with two fingers" to the secondary click'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple '\n  Trackpad\n\n'
    set_preferences
}

main