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
###### OS X Additions
- [x] Cheetah
- [ ] Dotfiles
  * [x] bash_aliases
  * [x] bash_autocomplete
  * [x] bash_exports
  * [x] bash_functions
  * [x] bash_options
  * [x] bash_profile
  * [x] bash_prompt
- [x] HomeBrew
  * [x] ffmpeg
- [x] MySQL
- [x] OS X Server
- [x] Python PIP (Package Manager)
  * [x] Python LXML

###### Applications
- [x] Auto-Sub (https://github.com/BenjV/autosub) :small_red_triangle:
  * [x] LaunchAgent
- [x] CouchPotato (https://couchpota.to)
  * [x] LaunchAgent
  * [ ] WebApp Proxy
  * [ ] SabNZBD+ integration
  * [ ] Spotweb integration
- [ ] NewzNAB
- [x] NzbToMedia
- [ ] Plex Home Theater
- [ ] Plex Media Server
  * [ ] Channel: Custom app store
  * [x] Channel: HelloHue (https://github.com/ledge74/HelloHue)
  * [x] Channel: TraktTV
- [x] SABnzbd+
  * [x] LaunchAgent
  * [ ] WebApp Proxy
  * [x] Folder creation
  * [x] NzbToMedia (SickBeard)
- [-] SickBeard -> Replaced by Sonarr
  * [x] LaunchAgent
  * [ ] WebApp Proxy
  * [x] SABnzbd+ integration (text step-by-step, not (yet) automated)
  * [x] Spotweb integration (text step-by-step, not (yet) automated) :small_red_triangle:
- [x] Sonarr
  * [ ] WebApp Proxy
- [x] Spotweb :small_red_triangle:
  * [x] API enablement check
  * [x] LaunchAgent: Periodic retrieval
  * [x] SabNZBD+ integration  (text step-by-step, not (yet) automated)
- [ ] etc.


Usefull links:
=====
###### Plex Information page(s)
- Client names: https://plex.tv/devices.xml
- User names: http://app.plex.tv/web/app#!/settings/users
- Friend names: https://plex.tv/pms/friends/all
- Current sessions: http://localhost:32400/status/sessions

###### Hue informatino page(s)
- Hue bridge IP: https://www.meethue.com/api/nupnp

###### OS X Server
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
- https://discussions.apple.com/thread/3566643?start=0&tstart=0
- http://www.themacosxserveradmin.com/2011_09_01_archive.html
- http://gathering.tweakers.net/forum/list_messages/1641228
- http://smashingfiasco.com/setting-up-aspnetmono-on-mac-os-server.html
- http://serverfault.com/questions/441722/apache-2-2-on-mountain-lion-ignoring-proxypass-and-sending-request-to-documentro

###### Github
- sphp https://github.com/conradkleinespel/sphp-osx

###### lsd error
- sudo mkdir /private/var/db/lsd
- xattr -wr com.apple.finder.copy.source.checksum#N 4 /private/var/db/lsd
- xattr -wr com.apple.metadata:_kTimeMachineNewestSnapshot 50 /private/var/db/lsd
- xattr -wr com.apple.metadata:_kTimeMachineOldestSnapshot 50 /private/var/db/lsd
- sudo touch /private/var/db/lsd/com.apple.lsdschemes.plist
- sudo /usr/libexec/repair_packages --repair --standard-pkgs --volume /
- https://support.apple.com/en-us/HT203129

###### OS X Server WebApp
- Running Node.js + Ghost as a webapp on OS X Mavericks with Server 3.2 (https://gist.github.com/joey-coleman/11111811)
- Creating a apache-proxy webapp on OS X using Server.app (https://gist.github.com/joey-coleman/10016371)
- Configuring Jenkins on OS X Server (http://pablin.org/2015/04/30/configuring-jenkins-on-os-x-server/)
- unning Django webapps with OS X Server.app (http://jelockwood.blogspot.nl/2013/06/running-django-webapps-with-os-x.html)

###### Other
- https://github.com/spotweb/spotweb/wiki/Performance-tips
- https://github.com/bstascavage/plexReport or https://github.com/jakewaldron/PlexEmail

###### Sed
- sudo sed -i "s/^;date.timezone =.*/date.timezone = Europe\/Amsterdam/" /etc/php5/*/php.ini
- sudo sed -i 's/"$/:\/usr\/local\/mysql\/bin"/' /etc/environment
- sudo sed -i 's/basedir		= \/usr/basedir		=\/usr\/local\/mysql/' /etc/mysql/my.cnf
- sudo sed -i 's/lc-messages-dir	= \/usr\/share\/mysql/lc-messages-dir = \/usr\/local\/mysql\/share\nlc-messages		=en_GB\n/' /etc/mysql/my.cnf
- sudo sed -i 's/myisam-recover	/myisam-recover-options	/' /etc/mysql/my.cnf
- sudo sed -i 's/key-buffer   /key-buffer-size /' /etc/mysql/my.cnf
- sed -i '/bind-address/d' /etc/mysql/my.cnf

###### Food for Thought
- http://stackoverflow.com/questions/26493762/yosemite-el-capitan-php-gd-mcrypt-installation
- http://www.michaelbagnall.com/blogs/php-gd-fixing-your-php-server-mac-os-x-without-homebrewmacports
- https://github.com/ElusiveMind/osx_server_enhancements
- https://github.com/philcook/brew-php-switcher
- https://www.reddit.com/r/PleX/wiki/tools

###### PHP Extentions
- mkdir -p /usr/local/php5530_ext

###### gettext
- cd ~/Github/osx_server_enhancements/packages/php-5.5.30/ext/gettext
- phpize
- ./configure --with-gettext=/usr/local/opt/gettext
- make clean
- make
- INSTALL_ROOT=/usr/local/php5530_ext make install

###### gd
- cd ~/Github/osx_server_enhancements/packages/php-5.5.30/ext/gd
- phpize
- sudo CFLAGS="-arch x86_64 -g -Os -pipe -no-cpp-precomp" CCFLAGS="-arch x86_64 -g -Os -pipe" CXXFLAGS="-arch x86_64 -g -Os -pipe" LDFLAGS="-arch x86_64 -bind_at_load" './configure' '--prefix=/usr' '--mandir=/usr/share/man' '--infodir=/usr/share/info' '--with-config-file-path=/etc/' '--with-config-file-scan-dir=/opt/local/var/db/php5' '--enable-bcmath' '--enable-ctype' '--enable-dom' '--enable-fileinfo' '--enable-filter' '--enable-hash' '--enable-json' '--enable-libxml' '--enable-pdo' '--enable-phar' '--enable-session' '--enable-simplexml' '--enable-tokenizer' '--enable-xml' '--enable-xmlreader' '--enable-xmlwriter' '--with-bz2=/opt/local' '--with-mhash=/opt/local' '--with-pcre-regex=/opt/local' '--with-readline=/opt/local' '--with-libxml-dir=/opt/local' '--with-zlib=/opt/local' '--disable-cgi' '--with-ldap=/usr' '--with-apxs2=/opt/local/apache2/bin/apxs' '--with-mysqli=/usr/local/mysql/bin/mysql_config' '--with-openssl' '--with-mcrypt=/opt/local/' '--with-mysql=/usr/local/mysql-5.1.42-osx10.6-x86_64/' '--with-iconv=/usr' '--with-curl=/opt/local' '--enable-mbstring' '--with-gd' '--with-jpeg-dir=/opt/local' '--with-png-dir=/opt/local' '--with-freetype-dir=/opt/local' '--enable-gd-native-ttf'  --with-ttf
- make clean
- make
- INSTALL_ROOT=/usr/local/php5530_ext make install

####### /Library/Server/Web/Config/php/extensions.ini
extension=/usr/local/php5530_ext/usr/lib/php/extensions/no-debug-non-zts-20121212/gd.so
extension=/usr/local/php5530_ext/usr/lib/php/extensions/no-debug-non-zts-20121212/gettext.so

####### Check
php -i


####### Fix slow starting Terminal
sudo rm /private/var/log/asl/*.asl
