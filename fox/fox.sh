#!/bin/bash

docker run -it --rm \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
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
