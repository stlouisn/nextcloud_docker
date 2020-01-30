#!/usr/bin/env bash

set -euo pipefail

# Output version of nextcloud from nextcloud:apache docker
echo "$((docker pull library/nextcloud:apache && docker run -it --rm library/nextcloud:apache /bin/bash -c env) | grep NEXTCLOUD_VERSION | awk -F '=' {'print $2'})"
