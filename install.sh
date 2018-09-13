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
		else
			yum update ;
			yum upgrade ;
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

fi