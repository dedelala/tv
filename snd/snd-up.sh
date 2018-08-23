#!/bin/bash

die() { echo "oh noes! $* gone bad" >&2; exit 1; }

jack_control start || die "start jack"

echo "waiting for jack"
timeout -t 15 sh -c "until jack_lsp &>/dev/null; do echo -n .; sleep 1; done"
echo

jack_lsp &>/dev/null || die "jack"

echo "alsa ports"
nohup alsa_in -d "hw:0,1" &
nohup alsa_out -d "hw:1,0" &

qp() {
    echo "queue patch $1 -> $2"
    nohup sh -c "sleep 1; until jack_connect \"$1\" \"$2\"; do sleep 1; done" &
}
qp "alsa_in:capture_1" "rack:sat-eq In #1"
qp "alsa_in:capture_2" "rack:sat-eq In #2"
qp "rack:sat-eq Out #1" "alsa_out:playback_1"
qp "rack:sat-eq Out #2" "alsa_out:playback_2"

echo "start rack"
calfjackhost --client rack -s $HOME/rack

