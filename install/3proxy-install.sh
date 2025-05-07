#!/usr/bin/env bash

# Copyright (c) 2025
# Author: xsandrk
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source:

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing 3proxy"
$STD wget https://github.com/3proxy/3proxy/releases/download/0.9.5/3proxy-0.9.5.x86_64.deb -O /tmp/3proxy-0.9.5.x86_64.deb
$STD apt install -y /tmp/3proxy-0.9.5.x86_64.deb
msg_info "Installed 3proxy"

msg_info "Configure 3proxy"
cat <<EOF >/etc/3proxy/conf/3proxy.cfg
nserver 8.8.8.8
nserver 8.8.4.4
nscache 65536

#log /logs/3proxy-%y%m%d.log D
#rotate 5

auth iponly
allow * * $/conf/domains.lst
parent 1000 socks5+ 127.0.0.1 1080
allow *
proxy
EOF

cat <<EOF >/etc/3proxy/conf/domains.lst
*themoviedb.org,*lostfilm.tv,*nnmclub.to,*youtube.com
EOF

systemctl start 3proxy

msg_info "Configured 3proxy"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
