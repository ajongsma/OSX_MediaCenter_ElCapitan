#!/bin/bash

main() {
  # Disable smart quotes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  # Disable smart dashes
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  print_result $? 'Disable smart quotes and dashes'
}

main
