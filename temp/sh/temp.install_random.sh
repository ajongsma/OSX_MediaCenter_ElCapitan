#!/usr/bin/env bash

 
 # Assume we're not on the UVic computers.
function UVic {
        local AT_UVIC = false
        echo $HELLO in function
}

# Check whether we can do a quick local install, since I've already 
# downloaded the .dmg and .zip files to my UVic Netdrive
if [[ $HOSTNAME = *".uvic.ca"* && $USER = *"sahoward"* ]]
	then
  	$AT_UVIC =  1;
fi

####################################
# Software acquisition              
####################################

chromium_version='43.0.2357.81'
chromium_url='http://downloads.sourceforge.net/sourceforge/osxportableapps/Chromium_OSX_'$chromium_version'.dmg'

iterm_version='2_1_1'
iterm_url='https://iterm2.com/downloads/beta/iTerm2-'$iterm_version'.zip'

sublimetext_version='3083'
sublimetext_url='http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%20'$sublimetext_version'.dmg'

cyberduck_version='4.7'
cyberduck_url='https://update.cyberduck.io/Cyberduck-'$cyberduck_version'.zip'

flux_version=''
flux_url='https://justgetflux.com/mac/Flux.zip'

spotify_version=''
spotify_url='https://www.spotify.com/Spotify.dmg'

# Begin moving files to Desktop

cd ~/Desktop;


if [[ "AT_UVIC" = true ]]; then
	echo ""
	echo "Copying the following files from UVic Individual Temp storage:"
	echo ""
	ln -s "/Volumes/UVic Individual Temp/s/sahoward" ~/Desktop/
	cp -vr "/Volumes/UVic Individual Temp/s/sahoward/workspace-OSX" ~/Desktop;
	echo ""
	echo "Finished copying."
	echo ""
else
	echo ""
	echo "Downloading Chromium, iTerm2, Cyberduck, Sublime Text 3, F.lux, and Spotify"
	echo ""
	mkdir ~/Desktop/workspace-OSX
	cd ~/Desktop/workspace-OSX
	curl -LO $chromium_url 
	curl -LO $iterm_url
	curl -LO $cyberduck_url
	curl -LO $sublimetext_url
	curl -LO $flux_url
	curl -Os $spotify_url
fi



echo ""
echo Now customizing Mac OS X settings.
echo ""
 
 
####################################
# General UI/UX                     
####################################
 
# Disable the "are you sure you want to open this file" dialog for apps on Desktop
xattr -d -r com.apple.quarantine ~/Desktop 
 
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0
 
# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
 
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
 
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
 
# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true
 
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Enable Text Selection in Quick Look Windows
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
killall Finder
 
# Always Show the User Library Folder
chflags nohidden ~/Library/
 
# Remove shadow from screenshot
defaults write com.apple.screencapture disable-shadow -bool true; killall SystemUIServer
 
# Show only currently active apps in the Mac OS X Dock
defaults write com.apple.dock static-only -bool TRUE
 

####################################
# Dock, Dashboard, and hot corners
####################################
 
# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true
 
# Set the icon size of Dock items to 36 pixels
if [[ $AT_UVIC = 1 ]]; then
		defaults write com.apple.dock tilesize -int 64
else
		defaults write com.apple.dock tilesize -int 36
fi
		
# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"
 
# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true
 
# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
 
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
 

####################################
# Chromium
####################################

echo ""
echo "Installing Chromium"
echo ""
cd ~/Desktop
open ~/Desktop/workspace-OSX/Chromium*.dmg
sleep 10
cp -R /Volumes/Chromium*/Chromium.app ~/Desktop
sleep 15
diskutil unmountDisk /Volumes/Chromium*
echo ""
echo "Done."
echo ""

####################################
# iTerm
####################################

echo ""
echo "Opening iTerm2 and installing colour schemes."
echo ""
cd ~/Desktop
unzip -oq ~/Desktop/workspace-OSX/iTerm*.zip
sleep 5
if [[ $AT_UVIC = 1 ]]; then
	# Install preferences
	~/Desktop/iTerm.app/Contents/MacOS/iTerm ~/Desktop/extensions/iterm/com.* 
	sleep 5
	# Install colour schemes
	open ~/Desktop/extensions/iterm/*.itermcolors
fi
echo ""
echo "Done."
echo ""
 
####################################
# Sublime Text
####################################
echo ""
echo "Installing Sublime Text 3."
echo ""
cd ~/Desktop
open ~/Desktop/Sublime*.dmg
sleep 10
cp -R /Volumes/Sublime\ Text/Sublime\ Text.app ~/Desktop/ &
sleep 5
diskutil unmountDisk /Volumes/Sublime*
open ~/Desktop/Sublime\ Text.app/Contents/MacOS/Sublime\ Text
sleep 5
if [[ $AT_UVIC = 1 ]]; then
	chmod u+x ~/Desktop/extensions/subl/Sublime\ Text
	killall Sublime\ Text
	cp ~/Desktop/extensions/subl/Sublime\ Text ~/Desktop/Sublime\ Text.app/Contents/MacOS/Sublime\ Text
fi

# add the "subl" launch shortcut
ln -s ~/Desktop/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
echo ""
echo "Done."
echo ""
 
####################################
# F.lux
####################################
 
echo ""
echo "Installing F.lux"
echo ""
cd ~/Desktop
unzip -oq ~/Desktop/Flux*.zip 
sleep 5
echo ""
echo "Done."
echo ""
 
####################################
# Spotify
####################################

echo ""
echo "Installing Spotify"
echo ""
cd ~/Desktop
open ~/Desktop/Spotify*.dmg
cp -R "/Volumes/Spotify*/Spotify.app" ~/Desktop
sleep 5
diskutil unmountDisk /Volumes/Spotify*
echo ""
echo "Done."
echo ""

 
####################################
# Cyberduck
####################################
echo ""
echo "Installing Cyberduck"
echo ""
cd ~/Desktop
unzip -oq ~/Desktop/Cyberduck*.zip
echo ""
echo "Done."
echo ""
 
####################################
# Clean Up			    
####################################

rm -r ~/Desktop/*.zip
rm -rf ~/Desktop/_*
killall Dock Finder iTerm Sublime\ Text Chromium
 
echo "Mac setup is complete."
sleep 3
echo ""
echo "Looks tight."
echo ""
sleep 2
echo ""
echo "Enjoy"
echo ""
sleep 3
killall Terminal
