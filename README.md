# tv!

WORK IN PROGRESS

It's a Void Linux setup for a tv computer. It doesn't do actual tv it's just a
web browser and a sound setup really. You'd probably need to change a bunch of
stuff depending on your setup.  This one uses nvidia video and intel sound
output.


## iso

Make a void live image with `build.sh`. Add any files to include to the `root/`
dir.


## install

- Boot the live image.
- Partition your disk according to the following layout or edit `root/usr/bin/tv-installer.sh` to suit your needs.
- Run `tv-installer.sh <hostname> <user> <disk>`.
- You will be prompted for the root password.


### disk layout

The `<disk>` is expected to be laid out as follows, eg for `/dev/sda`...

```
/dev/sda2    boot
/dev/sda3    swap
/dev/sda4    root
```


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


## firefox nonsense

Some config needs to be set on the first run to allow firefox to use alsa...

```
security.sandbox.content.level                  2
security.sandbox.content.syscall_whitelist      16
security.sandbox.content.read_path_whitelist    /dev/snd/,/root/.asoundrc
security.sandbox.content.write_path_whitelist   /dev/snd/
```

Source [John Tsiombikas](https://codelab.wordpress.com/2017/12/11/firefox-drops-alsa-apulse-to-the-rescue/).


## sound

The patch configuration is built in to the container in snd-up.sh, that may need to change.

