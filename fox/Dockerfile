from voidlinux/voidlinux as flasher

run xbps-install -Syy curl

workdir /root
run curl -L -o flash.tar.gz "https://fpdownload.adobe.com/get/flashplayer/pdc/30.0.0.154/flash_player_npapi_linux.x86_64.tar.gz"
run tar -xvzf flash.tar.gz

from voidlinux/voidlinux

run xbps-install -Syy alsa-lib apulse ca-certificates firefox mesa-nouveau-dri libGL xorg-fonts

run xbps-install -Syy libavcodec

copy --from=flasher /root/libflashplayer.so /usr/lib/mozilla/plugins/
copy --from=flasher /root/usr/* /usr/
copy .asoundrc /root/

entrypoint ["/usr/sbin/apulse","firefox"]
