from alpine as grabber

run apk --no-cache add curl

workdir /root
run curl "https://launcher.mojang.com/download/Minecraft.tar.gz" -o mc.tar.gz
run tar -xvzf mc.tar.gz

from voidlinux/voidlinux

run xbps-install -Syy openjdk-jre mesa-nouveau-dri libGL xorg-fonts alsa-lib \
  ca-certificates

copy .asoundrc /root/
copy --from=grabber /root/minecraft-launcher-* /opt/mc
