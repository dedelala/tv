#!/bin/bash

die() { echo "ehhh: $* not good"; exit 1; }

d="$(dirname "$(git rev-parse --absolute-git-dir)")" || die "repo root"

docker build -t tv-mklive:latest "$d/mklive" || die "docker build"

pkgs="socklog-void linux-firmware alsa-lib docker fortune-mod git zsh unzip zip"
pkgs="$pkgs xorg-minimal xf86-video-nouveau xhost xinit xorg-fonts xrandr"
pkgs="$pkgs dialog grub libXinerama libXft libEGL"

docker run --privileged -it --rm \
  -v "$d/root:/tv/root" \
  -v "$d/iso:/tv/iso" \
  tv-mklive:latest sh -c "./mklive.sh -p \"$pkgs\" -I /tv/root && cp *.iso /tv/iso"

