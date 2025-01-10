#!/bin/bash

set -e

[ -z "$1" -o -z "$2" -o -z "$3" ] && echo "USAGE: $(basename $0) <docker hub ip> <docker hub port> <cert file>" && exit 2

HUB_IP="$1"
HUB_PORT="$2"
CERT_FILE="$3"

sudo mkdir -p /etc/docker/certs.d/$HUB_IP:$HUB_PORT && sudo cp $CERT_FILE /etc/docker/certs.d/$HUB_IP:$HUB_PORT/ca.crt
