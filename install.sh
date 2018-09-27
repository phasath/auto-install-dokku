#!/bin/bash

HOST=''
PORT=''
USERNAME=''
USERNAME_TO_BE_CREATED=''
DOMAIN=''
IDENTITY_FILE_PATH=$(echo /home/$(whoami)/.ssh/id_rsa)
ALLOW_USERS=''

function show_help {
    echo -e "Server Setup Script\n\nUsage: ${0##*/} [-h?] [-H HOST IP] [-p PORT] [-u USERNAME] [-c USERNAME TO BE CREATED] [-d DOMAIN] [-i IDENTITY FILE PATH] [-a ALLOW USERS]\n\t-h Show this help\n\t-? Show this help\n\t-H Host IP to connect over SSH\n\t-p Port to connect through SSH\n\t-u Username used to connect\n\t-d Domain to add on dokku\n\t-c Username to be created. This will override -u user.\n\t-i Identity file path. Default is /home/$(whoami)/.ssh/id_rsa\n\t-a Allow Users on sshd_config. Ex:. 'raphael.sathler john.doe ze.ninguem'\n###### DON'T RUN THIS AS SUDO ######"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts h?p:u:d:H:c:i:a: opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    p)  PORT=$OPTARG
        ;;
    H)  HOST=$OPTARG
        ;;
    u)  USERNAME=$OPTARG
        ;;
    d)  DOMAIN=$OPTARG
        ;;
    c)  USERNAME_TO_BE_CREATED=$OPTARG
        ;;
    i)  IDENTITY_FILE_PATH=$OPTARG
        ;;
    a)  ALLOW_USERS=$OPTARG
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

if [[ $EUID == 0 ]] ; 
then
		echo "You are root. Please run it as your user (without sudo)\n" ;
        show_help
		exit 1
fi

echo -e "\n\nConnecting to $HOST using port $PORT as $USERNAME" ;

if [[ $USERNAME_TO_BE_CREATED ]]; then
    echo -e "\n\nCreating $USERNAME_TO_BE_CREATED on server $HOST" ;
    ssh $USERNAME@$HOST -p $PORT -t "sudo useradd -m $USERNAME_TO_BE_CREATED ; sudo passwd $USERNAME_TO_BE_CREATED ; sudo usermod -aG wheel $USERNAME_TO_BE_CREATED ;"
    echo -e "\n\nCopying public key from $USERNAME_TO_BE_CREATED to server $HOST" ;
    ssh-copy-id -i $IDENTITY_FILE_PATH.pub $USERNAME_TO_BE_CREATED@$HOST -p $PORT ;
    USERNAME=$USERNAME_TO_BE_CREATED ;
fi

echo -e "\n\nConnecting as $USERNAME to create the dapp.user and configuring all the necessary stuff to start the repository install script"
ssh $USERNAME@$HOST -p $PORT -A -i $IDENTITY_FILE_PATH -t "sudo useradd -c 'Usuário da DAPP' -m --system dapp.user ; sudo usermod -aG wheel dapp.user ;  sudo mkdir /conf ;"' if [ $(python -mplatform | grep -i Ubuntu) ]; then sudo apt-get install git ; else sudo yum install git ; fi ;'" sudo chown dapp.user:dapp.user -R /conf ; sudo chmod 775 -R /conf ; sudo usermod -aG dapp.user $USERNAME ;"
echo -e "\n\nConnecting as $USERNAME to clone the repository and start the script"
ssh $USERNAME@$HOST -p $PORT -A -i $IDENTITY_FILE_PATH -t "cd /conf && git clone ssh://git@git.dapp.cloud.fgv.br:777/source/cf-homog-web.git; cd /conf/cf-homog-web && sudo sh install_on_server.sh $DOMAIN $ALLOW_USERS"