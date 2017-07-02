#!/bin/sh

echo "deb http://ftp.debian.org/debian jessie-backports main" | sudo tee -a /etc/apt/sources.list

sudo apt-get update

gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
gpg -a --export 8B48AD6246925553 | sudo apt-key add --
gpg -a --export 7638D0442B90D010 | sudo apt-key add --

sudo apt-get -y --force-yes -t jessie-backports install pulseaudio pulseaudio-module-bluetooth libpulse-dev

sudo adduser pi pulse-access

sudo apt-get install -y expect

sudo apt-get install -y build-essential git xmltoman

sudo apt-get install -y autoconf automake libtool libdaemon-dev libasound2-dev libpopt-dev libconfig-dev

sudo apt-get install -y libavahi-compat-libdnssd-dev
sudo apt-get install -y avahi-daemon libavahi-client-dev

sudo apt-get install -y libssl-dev

sudo apt-get install -y libsoxr-dev

sudo apt-get install -y libsndfile1-dev 

sudo apt-get install -y bluez
 
rm -f -r alac
git clone https://github.com/mikebrady/alac.git
cd alac
autoreconf -fi
./configure
make
make install
ldconfig
cd ..

rm -f -r shairport-sync
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
git checkout development
autoreconf -i -f

./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --with-pa \
        --with-avahi \
        --with-alsa \
        --with-ssl=openssl \
        --with-soxr \
        --with-apple-alac \

make

getent group shairport-sync &>/dev/null || sudo groupadd -r shairport-sync >/dev/null
getent passwd shairport-sync &> /dev/null || sudo useradd -r -M -g shairport-sync -s /usr/bin/nologin -G audio shairport-sync >/dev/null

make install
cd ..

