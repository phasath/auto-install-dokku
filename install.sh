#!/bin/bash

HOST=$1
PORT=$2
USERNAME=$3
DOMAIN=$4

echo -e "Connecting to $HOST using port $PORT as $USERNAME"
ssh $USERNAME@$HOST -p $PORT -t "sudo useradd -c 'Usuário da DAPP' -m --system dapp.user ; sudo usermod -aG wheel dapp.user ;  sudo mkdir /conf ; if [ $(python -mplatform | grep -i Ubuntu) ]; then sudo apt-get install git ; else sudo yum install git ; fi ; sudo chown dapp.user:dapp.user -R /conf ; sudo chmod 775 -R /conf ; sudo usermod -aG dapp.user `whoami` ;"
ssh $USERNAME@$HOST -p $PORT -t "cd /conf && git clone ssh://git@git.dapp.cloud.fgv.br:777/source/cf-homog-web.git; cd /conf/cf-homog-web ; sudo sh install_on_server.sh $4"