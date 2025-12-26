#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: xsandrk
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/ggml-org/llama.cpp

# Import Functions and Setup
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# [4] Installation steps
msg_info "Installing Dependencies"
msg_ok "Installed Dependencies"


motd_ssh
customize
cleanup_lxc
