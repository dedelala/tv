#!/bin/bash

die() { echo "awww: $* not work soz"; exit 1; }

s="$HOME/src"
cd "$s" || die "cd src"
if ! [[ -d dots ]]; then
    git clone https://github.com/dedelala/dots.git || die "get dots"
    ./dots/dots.sh || die "dots.sh"
fi

for i in fox snd kakao sucka; do
    cd "$s/tv/$i" || die "cd $i"
    docker build -t "$i:latest" . || die "build $i"
done
cd "$s" || die "cd src"

if ! [[ -d dwm ]]; then
    git clone https://git.suckless.org/dwm || die "get dwm"
    cd dwm || die "cd dwm"
    git apply "$s/tv/dwm-start.patch" || die "patch dwm"
    cd "$s" || die "cd src"
fi
docker run -it --rm -v "$s/dwm:/src" -w /src \
  sucka:latest sh -c "make clean && make"

if ! [[ -d st ]]; then
    git clone https://git.suckless.org/st || die "get st"
fi
docker run -it --rm -v "$s/st:/src" -w /src \
  sucka:latest sh -c "make clean && make" || die "build st"

if ! [[ -d kakoune ]]; then
    git clone https://github.com/mawww/kakoune.git || die "get kakoune"
fi
docker run -it --rm -v "$s/kakoune:/src" -w /src/src \
  kakao:latest sh -c "make clean && make" || die "build kakoune"


