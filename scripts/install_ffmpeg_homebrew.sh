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

declare -a BREW_PACKAGES=(
    'ffmpeg'

)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## Install dependencies for ffmpeg: gettext, texi2html, yasm, x264, lame, libvo-aacenc, xvid, libpng, freetype, libogg, libvorbis, lua, libquvi, x265

main() {
	if ! cmd_exists 'brew'; then
		print_error 'Brew not detected'
    exit 1;
  fi

  local i=''
  local sourceFile=''
  local targetFile=''

  for i in ${BREW_PACKAGES[@]}; do
    sourceFile=$i

    if ! cmd_exists "$sourceFile"; then
      if [ "$sourceFile" == 'ffmpeg' ]; then
        #sourceFile='ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-speex --with-theora --with-tools'
        sourceFile='ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265 --with-tools'
      fi  
      
      brew install $sourceFile
    fi

    print_result $? 'Install '$sourceFile
  done
}

main