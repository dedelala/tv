# tv!

WORK IN PROGRESS

It's a Void Linux setup for a tv computer. It doesn't do actual tv it's just a web browser
and a sound setup really. You'd probably need to change a bunch of stuff depending on your setup.
This one uses nvidia video and intel sound output.

## host packages

- alsa-libs
- docker
- git
- zsh
- xorg-minimal
- xf86-video-nouveau
- xhost
- xinit
- xorg-fonts
- xrandr

## containers

- fox, runs firefox using apulse
- snd, runs jack and a calf lv2 host
- sucka, builds st and dwm
- kakao, builds kakoune

## host configuration

- alsa loopback device is set to index 0 on the host
- sv x runs startx as user x on startup
- x's xinitrc starts dwm
- dwm is patched to start fox and snd
