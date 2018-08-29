#!/bin/bash

die() { echo "awww: $* not work soz"; exit 1; }

u=$1
[[ -n "$u" ]] || { echo "usage: $0 <userlogin>" >&2; exit 64; }

chsh -s /bin/bash || die "root shell"
groupadd shutdown || die "shutdown group"
useradd -G audio,video,docker,shutdown -m -d /home/x -s /bin/zsh x || die "user x"
useradd -G wheel,audio,video,kvm,xbuilder,socklog,docker,shutdown \
  -m -d "/home/$u" -s /bin/zsh "$u" || die "user $u"

s="/home/$u/src"
git clone https://github.com/dedelala/dots.git "$s/dots" || die "get dots"
HOME="/home/$u" "$s/dots/dots.sh" || die "dots"

git clone --depth 1 https://github.com/mawww/kakoune.git "$s/kakoune" || die "get kakoune"
git clone --depth 1 https://git.suckless.org/st "$s/st" || die "get st"
git clone --depth 1 https://git.suckless.org/dwm "$s/dwm" || die "get dwm"
cd "$s/dwm" || die "cd dwm"
git apply - <<! || die "patch dwm"
diff --git a/dwm.c b/dwm.c
index 4465af1..b0019d8 100644
--- a/dwm.c
+++ b/dwm.c
@@ -2142,6 +2142,7 @@ main(int argc, char *argv[])
 		die("pledge");
 #endif /* __OpenBSD__ */
 	scan();
+	system("tv-start.sh &");
 	run();
 	cleanup();
 	XCloseDisplay(dpy);
!

cp -rpv /tv-bootstrap/u/{*,.[^\.]*} "/home/$u/" || die "$u files"
cp -rpv /tv-bootstrap/x/{*,.[^\.]*} "/home/x/" || die "x files"
rm -rf /tv-bootstrap

chown -R "$u:$u" "/home/$u" || die "chown home $u"
chown -R x:x /home/x || die "chown home x"

rule="%shutdown ALL=(ALL) NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, \
	/usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ"

tmp=$(mktemp) || die "mktemp"
trap 'rm -f "$tmp"' EXIT

cp -p /etc/sudoers "$tmp"
echo "$rule" >> "$tmp"
visudo -c -f "$tmp" || die "check sudoers"

cp -p "$tmp" /etc/sudoers
visudo -c || die "new sudoers"

