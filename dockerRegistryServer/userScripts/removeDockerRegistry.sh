#!/bin/bash

set -e

[ -z "$1" -o -z "$2" ] && echo "USAGE: $(basename $0) <docker hub ip> <docker hub port>" && exit 2

HUB_IP="$1"
HUB_PORT="$2"

sudo rm /etc/docker/certs.d/$HUB_IP:$HUB_PORT/* && sudo rmdir /etc/docker/certs.d/$HUB_IP:$HUB_PORT
