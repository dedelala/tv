#!/bin/bash

die() { echo "oh noes: $* sad face"; exit 1; }

[[ -e tvoid.zip ]] || die "missing tvoid.zip package"

xbps-install -Suyy || die "update"
xbps-install -Syy socklog-void linux-firmware alsa-libs docker fortune-mod git zsh \
  unzip zip xorg-minimal xf86-video-nouveau xhost xinit xorg-fonts xrandr || die "pkgs"

ln -s /etc/sv/socklog-unix /var/service/ || die "sv socklog-unix"
ln -s /etc/sv/nanoklogd /var/service/ || die "sv nanoklogd"
ln -s /etc/sv/docker /var/service/ || die "sv docker"

useradd -G wheel,floppy,audio,video,cdrom,optical,kvm,xbuilder,socklog,docker \
  -m -d /home/dede -s /bin/zsh dede || die "user dede"

useradd -G audio,video,docker -m -d /home/x -s /bin/zsh x || die "user x"

unzip tvoid.zip -d / || die "unzip package"
chown -R dede:dede /home/dede || die "chown dede"
chown -R x:x /home/x || die "chown user x"

su -c /home/dede/boots.sh dede || die "dede boots"
mv /home/dede/src/kakoune/src/kak.debug /usr/bin/kak || die "no kak"
mv /home/dede/src/dwm/dwm /usr/bin/dwm || die "no dwm"
mv /home/dede/src/st/st /usr/bin/st || die "no st"

ln -s /etc/sv/x /var/service/ || die "sv x"
