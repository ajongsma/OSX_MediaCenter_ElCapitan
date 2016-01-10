# OSX_MediaCenter
######El Capitan edition

![minions](img/cheering_minions.gif)

![El_Capitan](img/elcapitan_64x64.jpg)
![OSX_Server](img/osx_server_64x64.jpg)
![Plex_Client](img/plex_client_64x64.jpg)
![Plex_Server](img/plex_server_64x64.png)
![SABnzbd](img/sabnzbd_64x64.png)
![SickBeard](img/sickBeard_64x64.png)
![CouchPotato](img/couchpotato_64x64.png)
![Trakt](img/trakt_64x64.png)


Note:
=====
A clean install will erase all of the contents on your disk drive. Make sure to back up your important files, settings and apps before proceeding. If needed, upgrade the system to [El Capitan](https://itunes.apple.com/nl/app/os-x-el-capitan/id1018109117)

Performing a clean install:

1. Restart your Mac and hold down the Command key and the R key (cmd⌘+R). Press and hold these keys until the Apple logo appears.

2. For a clean install, open up Disk Utility and erase your main hard drive. Once you've done so, you can go back to the Install OS X Mavericks disk and choose "Install a new copy of OS X."


Install 
=====
###### Done
- HomeBrew
- MySQL
- OS X Server
- Python PIP (Package Manager)
- Python LXML
- 
- Cheetah
- CouchPotato (https://couchpota.to)
- SabNZBD+

###### In Progress
- Auto-Sub
- SickBeard
- Sonarr
- Spotweb
- Plex Media Server
- Plex Home Theater

###### ToDo
- Plex Media Server - Channel: Custom app store
- Plex Media Server - Channel: Hue
- Plex Media Server - Channel: TraktTV
- etc.



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
- https://github.com/alrra/dotfiles
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

#####Other
- sudo sed -i "s/^;date.timezone =.*/date.timezone = Europe\/Amsterdam/" /etc/php5/*/php.ini
- sudo sed -i 's/"$/:\/usr\/local\/mysql\/bin"/' /etc/environment
- sudo sed -i 's/basedir		= \/usr/basedir		=\/usr\/local\/mysql/' /etc/mysql/my.cnf
- sudo sed -i 's/lc-messages-dir	= \/usr\/share\/mysql/lc-messages-dir = \/usr\/local\/mysql\/share\nlc-messages		=en_GB\n/' /etc/mysql/my.cnf
- sudo sed -i 's/myisam-recover	/myisam-recover-options	/' /etc/mysql/my.cnf
- sudo sed -i 's/key-buffer   /key-buffer-size /' /etc/mysql/my.cnf
- sed -i '/bind-address/d' /etc/mysql/my.cnf
