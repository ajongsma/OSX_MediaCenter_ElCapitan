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

if [ -d dotfiles ]; then
  DOTFILES_SOURCE="."
elif [ -d ../dotfiles ]; then
  DOTFILES_SOURCE="../"
else
  echo "Dotfiles folder not found"
  exit 1
fi

declare -a FILES_TO_SYMLINK=(
    $DOTFILES_SOURCE'dotfiles/bash_aliases'
    $DOTFILES_SOURCE'dotfiles/bash_autocomplete'
    $DOTFILES_SOURCE'dotfiles/bash_colors'
    $DOTFILES_SOURCE'dotfiles/bash_exports'
    $DOTFILES_SOURCE'dotfiles/bash_functions'
    $DOTFILES_SOURCE'dotfiles/bash_logout'
    $DOTFILES_SOURCE'dotfiles/bash_options'
    $DOTFILES_SOURCE'dotfiles/bash_profile'
    $DOTFILES_SOURCE'dotfiles/bash_prompt'
    $DOTFILES_SOURCE'dotfiles/bashrc'
#    'shell/curlrc'
#    'shell/inputrc'
#    'dotfiles/screenrc'
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {
  local i=''
  local sourceFile=''
  local targetFile=''

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for i in ${FILES_TO_SYMLINK[@]}; do
      sourceFile="$(cd .. && pwd)/$i"
      targetFile="$HOME/testing/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

      echo  "--------------------"
      echo sourceFile
      echo targetFile
      echo  "--------------------"
      if [ ! -e "$targetFile" ]; then
          execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
          print_success "$targetFile → $sourceFile"
      else
          ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
          if answer_is_yes; then
              rm -rf "$targetFile"
              execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
          else
              print_error "$targetFile → $sourceFile"
          fi
      fi
  done





  print_result $? 'Dotfiles'
}

main
