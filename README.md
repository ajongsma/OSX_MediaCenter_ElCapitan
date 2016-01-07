# OSX_MediaCenter
OS X Media Center - El Capitan edition

![minions](http://www.donankleer.com/wp-content/uploads/2013/05/minions_cheering.gif)

![OSX_Mavericks](img/osx_mavericks_64x64.jpg)
![OSX_Server](img/osx_server_64x64.jpeg)
![Plex_Client](img/plex_client_64x64.jpeg)
![Plex_Server](img/plex_server_64x64.png)
![SABnzbd](img/sabnzbd_64x64.png)
![SickBeard](img/sickBeard_64x64.png)
![CouchPotato](img/couchpotato_64x64.png)
![Trakt](img/trakt_64x64.png)


Note:
=====
A clean install will erase all of the contents on your disk drive. Make sure to back up your important files, settings and apps before proceeding. If needed, upgrade the system to El Capitan (https://itunes.apple.com/nl/app/os-x-el-capitan/id1018109117) ![El Capitan](https://itunes.apple.com/nl/app/os-x-el-capitan/id1018109117)

Performing a clean install:

1. Restart your Mac and hold down the Command key and the R key (cmd⌘+R). Press and hold these keys until the Apple logo appears.

2. For a clean install, open up Disk Utility and erase your main hard drive. Once you've done so, you can go back to the Install OS X Mavericks disk and choose "Install a new copy of OS X."


Install 
=====
In Progress


#####Plex Information pages
- https://plex.tv/devices.xml
- https://plex.tv/pms/friends/all
- http://pooky.local:32400/status/sessions

#####OS X Server
- /Library/Server/Web/Config/apache2/sites/
- /Library/Server/Web/Config/Apache2/httpd_server_app.conf
- /Library/Server/web/config/apache2/httpd_server_app.conf.default

- sudo serveradmin settings web:definedWebApps
- sudo serveradmin start web / sudo serveradmin stop web
- sudo serveradmin fullstatus web
- sudo serveradmin settings web
- sudo serveradmin command web:command=restoreFactorySettings

- http://jason.pureconcepts.net/2014/11/configure-apache-virtualhost-mac-os-x/
- https://clickontyler.com/support/a/41/osx-server-app-virtualhostx/
- http://matt.coneybeare.me/how-to-map-plex-media-server-to-your-home-domain/

#####Dot files
- https://github.com/nicolashery/mac-dev-setup
- https://github.com/donnemartin/dev-setup
- https://github.com/paulirish/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/cowboy/dotfiles
- http://dotfiles.github.io
- https://github.com/natelandau/awesome-osx

#####Usefull
- sphp https://github.com/conradkleinespel/sphp-osx

#####lsd error
- sudo mkdir /private/var/db/lsd
- xattr -wr com.apple.finder.copy.source.checksum#N 4 /private/var/db/lsd
- xattr -wr com.apple.metadata:_kTimeMachineNewestSnapshot 50 /private/var/db/lsd
- xattr -wr com.apple.metadata:_kTimeMachineOldestSnapshot 50 /private/var/db/lsd
- sudo touch /private/var/db/lsd/com.apple.lsdschemes.plist
- sudo /usr/libexec/repair_packages --repair --standard-pkgs --volume /
- https://support.apple.com/en-us/HT203129
