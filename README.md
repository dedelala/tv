# tv!

Problem: I just wanna watch stuff, on my tv, using a web browser.
It should be simple, efficient, and also sound good.

Solution: Void Linux, dwm, docker. Firefox and jack audio in containers.
The system boots to a fullscreen web browser, no logins, no messing around.

The setup is hard coupled to the `nouveau` video and `hda-intel` alsa drivers.
It would be pretty easy to edit for other hardware.


## build

- Recommend adding your pubkey to `root/tv-bootstrap/u/.ssh/authorized_keys`.
- Create a void live image with `build.sh`. You will need docker.
- Output is saved to the `iso/` directory.


## install

- Boot the live image.
- Your disk must be laid out as detailed in the following section.
- Run `tv-installer.sh <user> <hostname> <disk>`.
- You will be prompted for the root password.
- Reboot and chill.


### disk layout

The `<disk>` is expected to be laid out as follows, eg for `/dev/sda`...

```
/dev/sda2    boot
/dev/sda3    swap
/dev/sda4    root
```


## host configuration

- alsa loopback device is set to index 0 on the host
- hda intel device is set to index 1
- sv x runs startx as user x on startup
- x's xinitrc starts dwm
- dwm is patched to start fox and snd


## containers

Docker containers are built from this repository.

- `dedelala/fox`, runs firefox using apulse
- `dedelala/snd`, runs jack and a calf lv2 host
- `dedelala/sucka`, builds st and dwm
- `dedelala/kakao`, builds kakoune




