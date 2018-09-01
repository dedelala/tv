#!/bin/bash

die() { echo "oh noes: $* sad face"; exit 1; }

v=/mnt/tv

user=$1
[[ -n $user ]] || { echo "usage: $0 <user> <hostname> <disk>" >&2; exit 64; }
host=$2
[[ -n $host ]] || { echo "usage: $0 <user> <hostname> <disk>" >&2; exit 64; }
disk=$3
[[ -n $disk ]] || { echo "usage: $0 <user> <hostname> <disk>" >&2; exit 64; }

net=$(ip route list default |awk '{print $5}') || die "net iface"

boot=${disk}2
s=$(lsblk -nr "$boot") || die "sz $boot"
bootsz=$(awk '{print $4}' <<< "$s") || die "sz $boot"

swap=${disk}3
s=$(lsblk -nr "$swap") || die "sz $swap"
swapsz=$(awk '{print $4}' <<< "$s") || die "sz $swap"

root=${disk}4
s=$(lsblk -nr "$root") || die "sz $root"
rootsz=$(awk '{print $4}' <<< "$s") || die "sz $root"

echo "====== void installer settings ======"
tee /tmp/.void-installer.conf <<!
KEYMAP us
NETWORK $net dhcp
SOURCE local
HOSTNAME $host
LOCALE en_US.UTF-8
TIMEZONE Australia/Melbourne
BOOTLOADER $disk
TEXTCONSOLE 0
MOUNTPOINT $boot ext2 $bootsz /boot 1
MOUNTPOINT $swap swap $swapsz swap 1
MOUNTPOINT $root ext4 $rootsz / 1
!
echo "====== running hack installer  ======"
read -n 1 -s -r -p "<any key to continue>"
hack-installer.sh || die "hack installer"

mkdir -p "$v"
mount "$root" "$v" || die "mount root"
mount "$boot" "$v/boot" || die "mount boot"
mount --bind /sys "$v/sys" || die "mount sys"
mount --bind /proc "$v/proc" || die "mount proc"
mount --bind /dev "$v/dev" || die "mount dev"

chroot "$v" tv-bootstrap.sh "$user" || die "tv bootstrap"

docker info &>/dev/null || die "docker is not running"
mount --bind "$v/var/lib/docker" /var/lib/docker || die "mount docker cache"

s="$v/home/$user/src"
docker run -it --rm -v "$s/kakoune:/src" -w /src/src dedelala/kakao:latest make \
  || die "build kakoune"
mv "$s/kakoune/src/kak.debug" "$v/usr/bin/kak" || die "no kak"

docker run -it --rm -v "$s/st:/src" -w /src dedelala/sucka:latest make \
  || die "build st"
mv "$s/st/st" "$v/usr/bin/" || die "no st"
tic -sx "$s/st/st.info" || die "st terminfo"

docker run -it --rm -v "$s/dwm:/src" -w /src dedelala/sucka:latest make \
  || die "build dwm"
mv "$s/dwm/dwm" "$v/usr/bin/" || die "no dwm"

docker pull dedelala/fox:latest
docker pull dedelala/snd:latest

rm -f "$v/usr/bin/tv-installer.sh" "$v/usr/bin/tv-bootstrap.sh" \
  "$v/usr/bin/hack-installer.sh"
for m in /var/lib/docker "$v/sys" "$v/proc" "$v/dev" "$v/boot" "$v"; do
    umount "$m"
done

echo "(=^~w~^=)/ you can reboot now honey"
