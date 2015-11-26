#!/bin/bash

value=$(defaults read com.apple.finder AppleShowAllFiles)

echo "**************************************************"
echo "\"Show All files\" is $value. (0='off' and 1='on')"
echo "**************************************************"

if [ $value -eq 0 ]
then
  echo "I just turned them on (1)"
  echo "**************************"
  defaults write com.apple.finder AppleShowAllFiles 1 && killall Finder
else
  echo "I just turned them off (0)"
  echo "**************************"
  defaults write com.apple.finder AppleShowAllFiles 0 && killall Finder
fi
