#!/bin/bash

xhost + 2>&1

docker run -d --rm \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$HOME/fox/cache:/root/.cache/mozilla" \
  -v "$HOME/fox/mozilla:/root/.mozilla" \
  -e DISPLAY=unix:0 \
  -e GDK_SCALE \
  -e GDK_DPI_SCALE \
  --device /dev/snd \
  --device /dev/dri \
  --cpuset-cpus 0 \
  --memory 2gb \
  --shm-size 2gb \
  --net host \
  --name fox \
  fox:latest

docker run -d --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/snd:/root \
  -e DISPLAY=unix:0 \
  --device /dev/snd \
  --device /dev/dri \
  --cpuset-cpus 0 \
  --memory 2gb \
  --shm-size 2gb \
  --name snd \
  snd:latest snd-up.sh

