from alpine as grabber

run apk --no-cache add curl

workdir /root
run curl "https://launcher.mojang.com/download/Minecraft.tar.gz" -o mc.tar.gz
run tar -xvzf mc.tar.gz

workdir /root
run curl -L -o flash.tar.gz "https://fpdownload.adobe.com/get/flashplayer/pdc/30.0.0.154/flash_player_npapi_linux.x86_64.tar.gz"
run tar -xvzf flash.tar.gz

from voidlinux/voidlinux

run xbps-install -Syy openjdk mesa-nouveau-dri libGL xorg-fonts alsa-lib \
  ca-certificates

copy .asoundrc /root/
copy --from=grabber /root/minecraft-launcher-* /opt/mc
