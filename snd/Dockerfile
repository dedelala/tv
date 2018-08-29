from voidlinux/voidlinux as patchy

run xbps-install -Syy curl unzip

run curl -L -o /patchy.zip https://github.com/dedelala/patchy/releases/download/v0.1.0/patchy-linux.zip
workdir /
run unzip patchy.zip

from voidlinux/voidlinux

run xbps-install -Syy alsa-lib alsa-utils jack lv2 calf njconnect jack_capture \
  mesa-nouveau-dri libGL xorg-fonts

copy --from=patchy /patchy /usr/bin/
copy *.sh /usr/bin/

entrypoint ["/bin/bash"]
