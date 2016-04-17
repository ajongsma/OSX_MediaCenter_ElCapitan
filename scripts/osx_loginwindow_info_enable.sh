#!/bin/bash

main() {
  # Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


  print_result $? 'Enhance login window'
}

main
