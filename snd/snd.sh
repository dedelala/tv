#!/bin/bash

docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix:0 \
  --device /dev/snd \
  --device /dev/dri \
  --cpuset-cpus 0 \
  --memory 2gb \
  --shm-size 2gb \
  --name snd \
  snd:latest
