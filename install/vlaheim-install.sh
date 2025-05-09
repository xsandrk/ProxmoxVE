#!/usr/bin/env bash

# Copyright (c) 2025 xsandrk
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

msg_info "Installing SteamCMD"
$STD apt-get install -y gpg
$STD add-apt-repository multiverse
dpkg --add-architecture i386
apt update
$STD apt install steamcmd
msg_ok "Installed SteamCMD"

msg_info "Installing Valheim Server"
steamcmd +login anonymous +force_install_dir ./valheim/ +app_update 896660 validate +quit
msg_ok "Installed Valheim Server"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
