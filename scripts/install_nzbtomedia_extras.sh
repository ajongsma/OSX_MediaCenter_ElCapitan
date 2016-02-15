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
  if folder_exists $NZBTOMEDIA_FOLDER; then
    if ! cmd_exists 'brew'; then
      print_error 'Homebrew required'
      exit 1
    fi

    brew update && brew upgrade

    if ! cmd_exists 'x264'; then
      brew install x264
    fi

    if ! cmd_exists 'x265'; then
      brew install x265
    fi

    if ! cmd_exists 'freetype'; then
      brew install freetype
    fi

    if ! cmd_exists 'libvorbis'; then
      brew install libvorbis
    fi

    if ! cmd_exists 'opus'; then
      brew install opus
    fi

    if ! cmd_exists 'libvpx'; then
      brew install libvpx
    fi

    if ! cmd_exists 'ffmpeg'; then
      brew uninstall ffmpeg
    fi
    
    if ! cmd_exists '7z'; then
      brew uninstall p7zip
    fi

    brew install ffmpeg --with-fdk-aac --with-libfdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x264 --with-x265

    print_result $? 'Download NzbToMedia Extras'
  fi

  print_result $? 'NzbToMedia Extras'
}

main
