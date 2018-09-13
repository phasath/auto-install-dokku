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
fi