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

msg_info "Installing Samba"
$STD apt-get install -y samba
msg_info "Installed Samba"

cat <<EOF >/etc/samba/smb.conf
[global]
   workgroup = HOMELAB
   server string = Samba Server in LXC
   security = user
   map to guest = Bad User
   name resolve order = bcast host
   dns proxy = no
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   usershare allow guests = no

[dlna]
   path = /mnt/cloud_data/DLNA
   browsable = yes
   read only = no
   guest ok = no
   create mask = 0775
   directory mask = 0775
   valid users = @samba-users
EOF

groupadd samba-users
useradd -M -G samba-users sambauser
smbpasswd -a sambauser
echo "sambauser:changeme" | chpasswd

chown -R root:samba-users /mnt/clooud_data
chmod -R 777 /mnt/clooud_data

msg_info "Installed Samba"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
