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
#  execute 'defaults write com.apple.Safari AutoOpenSafeDownloads -bool false' \
#    'Disable opening "safe" files automatically'

  execute 'defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true' \
    'Set backspace key to go to the previous page in history'

  execute 'defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true &&
       defaults write com.apple.Safari IncludeDevelopMenu -bool true &&
       defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true' \
    'Enable the "Develop" menu and the "Web Inspector"'

  execute 'defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false' \
    'Set search type to "Contains" instead of "Starts With"'

  execute 'defaults write com.apple.Safari HomePage -string "about:blank"' \
    'Set home page to "about:blank"'

  execute 'defaults write com.apple.Safari IncludeInternalDebugMenu -bool true' \
    'Enable "Debug" menu'

#  execute 'defaults write com.apple.Safari ShowFavoritesBar -bool false' \
#    'Hide bookmarks bar by default'

  execute 'defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true' \
    'Show the full URL in the address bar'

#  execute 'defaults write com.apple.Safari SuppressSearchSuggestions -bool true &&
#      defaults write com.apple.Safari UniversalSearchEnabled -bool false' \
#    'Don’t send search queries to Apple'

  execute 'defaults write NSGlobalDomain WebKitDeveloperExtras -bool true' \
    'Add a context menu item for showing the "Web Inspector" in web views'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple '\n  Safari\n\n'
    set_preferences

    killall 'Safari' &> /dev/null
}

main