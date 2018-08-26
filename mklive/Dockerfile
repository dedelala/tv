from voidlinux/voidlinux:latest

run xbps-install -Suyy
run xbps-install -Syy git make liblz4

workdir /root
run git clone https://github.com/void-linux/void-mklive.git
workdir /root/void-mklive
run make
