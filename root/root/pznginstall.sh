#!/bin/bash
cd /root
#wget https://github.com/pzs-ng/pzs-ng/archive/master.zip
## repos has moved?
wget https://github.com/glftpd/pzs-ng/archive/refs/heads/master.zip
unzip master.zip -d /glftpd/ftp-data/
rm master.zip
cd /glftpd/ftp-data/pzs-ng-master
apt-get update
install_clean gcc file make libssl-dev libc6-dev lynx libflac-dev
/glftpd/libcopy.sh /glftpd
#./configure 
./configure --build=aarch64-unknown-linux-gnu --enable-flac
pwd
sed -i 's/#define sfv_dirs.*/#define sfv_dirs                     "\/site\/archive\/tv\/ \/site\/archive\/xvid\/ \/site\/audiobook\/ \/site\/dvdr\/ \/site\/ebook\/ \/site\/flac\/ \/site\/games\/ \/site\/mp3\/ \/site\/psp\/ \/site\/requests\/ \/site\/tv-x264\/ \/site\/x264\/ \/site\/x265-2160\/\"/' zipscript/conf/zsconfig.h
sed -i 's/#define zip_dirs.*/#define zip_dirs                     "\/site\/dump\/' zipscript/conf/zsconfig.h
sed -i 's/#define check_for_missing_nfo_dirs.*/#define check_for_missing_nfo_dirs   "\/site\/archive\/tv\/ \/site\/archive\/xvid\/ \/site\/audiobook\/ \/site\/dvdr\/ \/site\/ebook\/ \/site\/flac\/ \/site\/games\/ \/site\/mp3\/ \/site\/psp\/ \/site\/requests\/ \/site\/tv-x264\/ \/site\/x264\/ \/site\/x265-2160\/\"/' zipscript/conf/zsconfig.h
sed -i 's/#define cleanupdirs .*/#define cleanupdirs                  "\/site\/archive\/tv\/ \/site\/archive\/xvid\/ \/site\/audiobook\/ \/site\/dvdr\/ \/site\/ebook\/ \/site\/flac\/ \/site\/games\/ \/site\/mp3\/ \/site\/psp\/ \/site\/requests\/ \/site\/tv-x264\/ \/site\/x264\/ \/site\/x265-2160\/\"/' zipscript/conf/zsconfig.h
sed -i 's/#define noforce_sfv_first_dirs.*/#define noforce_sfv_first_dirs       "\/site\/requests\/\"/' zipscript/conf/zsconfig.h
sed -i 's/#define short_sitename.*/#define short_sitename               \"CS\"/' zipscript/conf/zsconfig.h

sed -i 's/define GROUPFILE .*/define GROUPFILE                                 "\/ftp-data\/group\"/' zipscript/include/zsconfig.defaults.h
sed -i 's/define PASSWDFILE .*/define PASSWDFILE                                "\/ftp-data\/passwd\"/' zipscript/include/zsconfig.defaults.h
sed -i 's/etc\/group/ftp-data\/group/g' scripts/audio-genre/audio-genre-create.sh

cp zipscript/conf/zsconfig.h zipscript/conf/zsconfig.h.vafan 
make
make install
echo "
calc_crc        *
post_check      /bin/zipscript-c *
cscript         DELE                    post    /bin/postdel
cscript         RMD                     post    /bin/datacleaner
cscript         SITE[:space:]NUKE       post    /bin/cleanup
cscript         SITE[:space:]UNNUKE     post    /bin/postunnuke
cscript         SITE[:space:]WIPE       post    /bin/cleanup
site_cmd        RESCAN                  EXEC    /bin/rescan
custom-rescan   !8      *
cscript         RETR                    post    /bin/dl_speedtest
site_cmd request       EXEC    /bin/tur-request.sh request
site_cmd reqfilled     EXEC    /bin/tur-request.sh reqfilled
site_cmd requests      EXEC    /bin/tur-request.sh status
site_cmd reqdel        EXEC    /bin/tur-request.sh reqdel
site_cmd reqwipe       EXEC    /bin/tur-request.sh reqwipe
custom-request         *
custom-reqfilled       *
custom-requests        *
custom-reqdel          *
custom-reqwipe         *" >> /glftpd/ftp-data/glftpd.conf

#psxc-imdb

# Install psxc-imdb
cd /glftpd/ftp-data/pzs-ng-master/scripts/psxc-imdb
if [ -f ".install.vars" ] ; then rm .install.vars ; fi
if [ -d ".install" ] ; then rm -rf .install ; fi
{ echo 7; echo; echo ; echo "/glftpd/ftp-data/glftpd.conf"; echo -; echo; echo ; echo n; echo ; echo n; echo; echo n; echo ; echo n; echo ; echo n; echo ; echo n; echo ; echo n; echo ; echo n; echo; echo n; echo ; echo ; echo; echo ; echo ; echo n; echo n; echo ; echo x; } | TERM=xterm ./installer.sh

# install dependencies
cd /glftpd/ftp-data/pzs-ng-master/scripts/psxc-imdb/extras
{ echo ; echo ; } | ./psxc-imdb-sanity.sh

# For audio_script
chmod +s /glftpd/bin/ng-chown
