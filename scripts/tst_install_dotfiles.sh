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

declare -a FILES_TO_SYMLINK=(
    'dotfiles/bash_aliases'
    'dotfiles/bash_autocomplete'
    'dotfiles/bash_colors'
    'dotfiles/bash_exports'
    'dotfiles/bash_functions'
    'dotfiles/bash_logout'
    'dotfiles/bash_options'
    'dotfiles/bash_profile'
    'dotfiles/bash_prompt'
    'dotfiles/bashrc'
#    'shell/curlrc'
#    'shell/inputrc'
#    'dotfiles/screenrc'
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {






  print_result $? 'SabNZBD'
}

main
