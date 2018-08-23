#!/bin/bash

die() { echo "oh noes: $* sad face"; exit 1; }

xbps-install -Suyy || die "update"
xbps-install -Syy socklog-void linux-firmware alsa-libs docker fortune-mod git zsh \
  unzip zip xorg-minimal xf86-video-nouveau xhost xinit xorg-fonts xrandr || die "pkgs"

ln -s /etc/sv/socklog-unix /var/service/ || die "sv socklog-unix"
ln -s /etc/sv/nanoklogd /var/service/ || die "sv nanoklogd"
ln -s /etc/sv/docker /var/service/ || die "sv docker"

useradd -G audio,video,docker -m -d /home/x -s /bin/zsh x || die "user x"
useradd -G wheel,audio,video,kvm,xbuilder,socklog,docker,x \
  -m -d /home/dede -s /bin/zsh dede || die "user dede"

s=/home/dede/src
git clone https://github.com/dedelala/tv.git "$s/tv" || die "tv.git"
cp -R "$s/tv/conf/"* / || die "tv conf"

chown -R dede:dede /home/dede || die "chown dede"
chown -R x:x /home/x || die "chown user x"
chmod 770 /home/x || die "chmod user x home"

su -c "$s/tv/build.sh" dede || die "build.sh"
mv "$s/kakoune/src/kak.debug" /usr/bin/kak || die "no kak"
mv "$s/dwm/dwm" /usr/bin/dwm || die "no dwm"
mv "$s/st/st" /usr/bin/st || die "no st"

ln -s /etc/sv/x /var/service/ || die "sv x"

