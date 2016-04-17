#!/bin/bash

main() {
  # Enable the dark mode toggle of control-option-command-T
  sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

  print_result $? 'Disable smart quotes and dashes'
}

main
