#!/bin/bash

#Script to install all the necessary things
if [[ $EUID > 0 ]] ; 
then
		echo "You are not root. Please run it as root/sudo" ;
		exit 1
else

		# Configuring the server with necessary files
		echo -e "Configuring the server"

		#Running updates
		echo -e "Updating the packages"
		if [ $(python -mplatform | grep -i Ubuntu) ]; then
			apt-get update ;
			apt-get upgrade ;
			apt-get install git ;
		else
			yum update ;
			yum upgrade ;
			yum install git ;
		fi

		#Configuring the SSH
		echo -e "\n\tSSH" ;
		echo -e "\t\tCopying files..." ;
		cp -r ssh/* /etc/ssh ;

		echo -e "\t\tSetting permissions..." ;
		chmod 600 /etc/ssh/sshd_config ;
		chmod 640 /etc/ssh/ssh_host_* ;
		# TIC gave us machines that holds a group "ssh_keys" that are owners of private ssh files
		if [ $(getent group ssh_keys) ]; then
			chown root:ssh_keys /etc/ssh/ssh_host_* ;
		else
			chown root:root /etc/ssh/ssh_host_* ;
		fi
		chown root:root /etc/ssh/ssh_host_*.pub ;
		chmod 644 /etc/ssh/ssh_host_*.pub ;

		echo -e "\n\tFriendly Shell" ;
		echo -e "\t\tCopying files..." ;
		mkdir -p /usr/src/scripts && cp friendly_shell/dymotd /usr/src/scripts ;
		echo -e "\t\tSetting permissions..." ;
		chmod 755 /usr/src/scripts/dymotd ;

		echo -e "\n\tProfile"
		echo -e "\t\tCopying files..." ;
		cp friendly_shell/profile /etc/profile ;
		echo -e "\t\tSetting permissions..." ;
		chmod 644 /etc/profile
		echo -e "\nEverything configured" ;

		echo -e "\n\nSetting up DOKKU" ;

		echo -e "\tGetting DOKKU lastest release" ;
		#Exporting the python enconding as we're using python2
		export PYTHONIOENCODING=utf8
		DOKKU_LATEST=$(curl https://api.github.com/repos/dokku/dokku/tags | python2 -c "import sys,json; print json.load(sys.stdin)[0]['name']")

		echo -e "\tDownloading DOKKU lastest release" ;
		wget --directory-prefix=/tmp https://raw.githubusercontent.com/dokku/dokku/$DOKKU_LATEST/bootstrap.sh
		
		echo -e "\tInstalling DOKKU" ;
		DOKKU_TAG=$DOKKU_LATEST bash /tmp/bootstrap.sh

		echo -e "\tConfiguring web ports for DOKKU" ;
		if [ $(python -mplatform | grep -i Ubuntu) ]; then
			ufw allow http ;
			ufw allow https ;
		else
			firewall-cmd --zone=public --add-port=80/tcp --permanent
			firewall-cmd --zone=public --add-port=443/tcp --permanent
		fi

		echo -e "\tAdding DOKKU to wheel group" ;
		usermod -aG wheel dokku ;

		echo -e "\t Adding DOKKU domain" ;
		dokku domains:add-global $1

		echo -e "\tAdding SSH Keys to DOKKU" ;
		cd pub_keys ;
		for pkey in * ; do
			if [[ $pkey = *'.pub' ]]; then
				echo -e "\t\tAdding $pkey key "
				dokku ssh-keys:add $pkey $pkey
			fi
		done

fi