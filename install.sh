#!/bin/bash

HOST=''
PORT=''
USERNAME=''
USERNAME_TO_BE_CREATED=''
DOMAIN=''
IDENTITY_FILE_PATH=$(echo /home/$(whoami)/.ssh/id_rsa.pub)

function show_help {
    echo -e "Server Setup Script\n\nUsage: ${0##*/} [-h?] [-H HOST IP] [-p PORT] [-u USERNAME] [-c USERNAME TO BE CREATED] [-d DOMAIN] [-i IDENTITY FILE PATH]\n\t-h Show this help\n\t-? Show this help\n\t-H Host IP to connect over SSH\n\t-p Port to connect through SSH\n\t-u Username used to connect\n\t-d Domain to add on dokku\n\t-c Username to be created. This will override -u user.\n\t-i Identity file path. Default is /home/$(whoami)/.ssh/id_rsa.pub\n\n###### DON'T RUN THIS AS SUDO ######"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts h?p:u:d:H:c:i: opt; do
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

# if [[ $USERNAME_TO_BE_CREATED ]]; then
#     echo -e "\n\nCreating $USERNAME_TO_BE_CREATED on server $HOST" ;
#     ssh $USERNAME@$HOST -p $PORT -t "sudo useradd -m $USERNAME_TO_BE_CREATED ; sudo passwd $USERNAME_TO_BE_CREATED ; sudo usermod -aG wheel $USERNAME_TO_BE_CREATED ;"
#     echo -e "\n\nCopying public key from $USERNAME_TO_BE_CREATED to server $HOST" ;
#     ssh-copy-id $USERNAME_TO_BE_CREATED@$HOST -p $PORT ;
#     USERNAME=$USERNAME_TO_BE_CREATED ;
# fi