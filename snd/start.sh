#!/bin/bash

die() { echo "oh noes! $* gone bad" >&2; exit 1; }

jack_control start || die "start jack"
timeout 15 sh -c "until jack_lsp &>/dev/null; do sleep 1; done"
jack_lsp &>/dev/null || die "jack"

nohup alsa_in -d "hw:0,1" &
nohup alsa_out -d "hw:1,0" &
amixer -D "hw:1" sset Master playback 0dB unmute

nohup patchy -w 1m recall "$HOME/rack.patch" &
calfjackhost --client rack -s "$HOME/rack.plugs"

