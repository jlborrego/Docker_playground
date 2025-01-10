#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath $0))

[ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ] && echo "USAGE: $(basename $0) <docker hub ip> <docker hub port> <user> <password>" && exit 2

HUB_IP="$1"
HUB_PORT="$2"
HUB_USER="$3"
HUB_PASS="$4"

$SCRIPT_DIR/userScripts/addDockerRegistry.sh $HUB_IP $HUB_PORT cert/selfsigned.crt

docker pull ubuntu:16.04 \
    && echo $HUB_PASS | docker login --username $HUB_USER --password-stdin $HUB_IP:$HUB_PORT \
    && docker tag ubuntu:16.04 $HUB_IP:$HUB_PORT/my-ubuntu \
    && docker push $HUB_IP:$HUB_PORT/my-ubuntu:latest \
    && docker image remove ubuntu:16.04 \
    && docker image remove $HUB_IP:$HUB_PORT/my-ubuntu \
    && docker pull $HUB_IP:$HUB_PORT/my-ubuntu \
    && echo "Test OK" \
    || echo "Test FAILED"

$SCRIPT_DIR/userScripts/removeDockerRegistry.sh $HUB_IP $HUB_PORT
