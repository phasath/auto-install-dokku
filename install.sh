#!/bin/bash

#Script to install all the necessary things
if [[ $EUID > 0 ]] ; 
then
		echo "You are not root. Please run it as root/sudo" ;
		exit 1
else

		# Configuring the server with necessary files
		echo -e "Configuring the server"

fi