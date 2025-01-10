#!/bin/bash

set -e

SCRIPT_DIR=$(dirname $(realpath $0))

[ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ] && echo "USAGE: $(basename $0) <docker hub ip> <docker hub port> <user> <password>" && exit 2

HUB_IP="$1"
HUB_PORT="$2"
HUB_USER="$3"
HUB_PASS="$4"

HUB_DATA_DIR=$SCRIPT_DIR/'hubData'
AUTH_DIR=$SCRIPT_DIR/'auth'
CERT_DIR=$SCRIPT_DIR/'cert'
GENERATE_DIR="$HUB_DATA_DIR $AUTH_DIR $CERT_DIR"

# Firt stop the server, if any
$SCRIPT_DIR/stop.sh &> /dev/null || true

# Generate dirs
for DIR in $GENERATE_DIR; do
        [ -d $DIR ] || mkdir $DIR
done

# Generate auth credentials
docker run --rm \
  --entrypoint htpasswd \
  httpd:2 -Bbn $HUB_USER $HUB_PASS > auth/htpasswd

# Access dirs
sudo chmod 777 -R \
        $HUB_DATA_DIR
sudo chmod 755 -R \
        $AUTH_DIR \
        $CERT_DIR

# SSL cert generation
[[ $HUB_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && IP_OR_DNS="IP" || IP_OR_DNS="DNS"
cat $SCRIPT_DIR/sslcert.conf | sed "s/HUB_IP/${HUB_IP}/g" | sed "s/IP_OR_DNS/${IP_OR_DNS}/g" > sslcert.conf.gen
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $CERT_DIR/selfsigned.key -out $CERT_DIR/selfsigned.crt -config sslcert.conf.gen

# Run Docker Hub Server docker
docker run -d \
        -p $HUB_PORT:5000 \
        --restart=always \
        -v $AUTH_DIR:/auth \
        -v $CERT_DIR:/cert \
        -v $HUB_DATA_DIR:/var/lib/registry \
        -e "REGISTRY_AUTH=htpasswd" \
        -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
        -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
        -e REGISTRY_HTTP_TLS_CERTIFICATE=/cert/selfsigned.crt \
        -e REGISTRY_HTTP_TLS_KEY=/cert/selfsigned.key \
        --name hub-server \
        registry:2

rm sslcert.conf.gen
