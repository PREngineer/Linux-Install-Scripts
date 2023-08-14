#!/bin/bash
# Script Name: Check Network Settings
# Author: PREngineer (Jorge Pabon) - pianistapr@hotmail.com
# Publisher: Jorge Pabon
# License: Personal Use (1 device)
###########################################################

# Color definition variables
YELLOW='\e[33;3m'
RED='\e[91m'
BLACK='\033[0m'
CYAN='\e[96m'
GREEN='\e[92m'

SCRIPTPATH=$(pwd)

function pause()
{
   read -p "$*"
}

function title()
{
	# Make sure to clear the Terminal
	clear

	# Display the Title Information
	echo 
	echo -e $RED
	echo -e "╔══════════════════════════════════════════════╗"
	echo -e "║      ██╗██╗   ██╗██╗ ██████╗███████╗██████╗  ║"
	echo -e "║      ██║██║   ██║██║██╔════╝██╔════╝██╔══██╗ ║"
	echo -e "║      ██║██║   ██║██║██║     █████╗  ██████╔╝ ║"
	echo -e "║ ██   ██║██║   ██║██║██║     ██╔══╝  ██╔══██╗ ║"
	echo -e "║ ╚█████╔╝╚██████╔╝██║╚██████╗███████╗██║  ██║ ║"
	echo -e "║  ╚════╝  ╚═════╝ ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ║"
	echo -e "╚══════════════════════════════════════════════╝ for Orange Pis"
	echo -e $CYAN"          Brought to you by PREngineer"
	echo
	echo -e $GREEN'Check Network Settings'$BLACK
	echo

	agree
}

function agree()
{
	########################### Show AGREEMENT Information ###########################

	echo -e "╔═════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
	echo -e '║'$RED' 1. This tool has been tested on Ubuntu (Server & Desktop).'$BLACK'                                              ║'
	echo -e '║'$RED' 2. The author(s) cannot be held accountable for any problems that might occur if you run this tool.'$BLACK'     ║'
	echo -e '║'$RED' 3. Proceed only if you authorize this tool to make changes to your system.'$BLACK'                              ║'
	echo -e '║═════════════════════════════════════════════════════════════════════════════════════════════════════════║'
	echo -e '║'$RED'        CONTINUE TO AGREE.  OTHERWISE PRESS    [ C T R L   +   C ]'$BLACK'                                       ║'
	echo -e '╚═════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
	echo
}

########################### Show Menu Options ###########################
function options()
{
	title

	echo -e $YELLOW'@---@---@---@---@---@--- CHOOSE ---@---@---@---@---@---@'
	echo -e $YELLOW'[01] '$BLACK'View - Running Details'
	echo -e $YELLOW'[02] '$BLACK'View - Configuration File Details'
	echo -e $YELLOW'[03] '$BLACK'View - Primary DNS'
	echo
	echo -e $YELLOW'@---@---@---@---@---@-- ADAPTERS --@---@---@---@---@---@'
	echo -e $YELLOW'[04] '$BLACK'View - Available WiFi Adapter(s)'
	echo -e $YELLOW'[05] '$BLACK'View - Available Ethernet Adapter(s)'
	echo -e $YELLOW'[06] '$BLACK'View - Registered WiFi Adapter(s)'
	echo
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo -e $YELLOW'[07] '$BLACK'Test - Internet Speed (Speedtest)'
	echo
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo -e $YELLOW'[99] '$BLACK'Exit - Go back to Main Menu'
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo
	echo -e 'Type your choice and press [ENTER]: '
	
	read option

	case $option in

		1 | 01)
	        display_running
	        ;;

	    2 | 02)
	        display_config
	        ;;

	  	3 | 03)
	        display_dns
	        ;;

	  	4 | 04)
	        display_wifi
	        ;;

	   	5 | 05)
	        display_lan
	        ;;

	    6 | 06)
	        display_registered_wifi
	        ;;

	    7 | 07)
	        speed_test
	        ;;

	    99 | 99)
			cd $SCRIPTPATH
			sudo ./juicer.sh
			exit 0
	        ;;

	    *)
	       	echo -e $RED'Invalid Option'$BLACK
			options
	esac
}


########################### Show Running Details ###########################
function display_running()
{
	title

	echo 
	echo -e $YELLOW'--->Retrieving Running Network Details...'$BLACK
	echo 

	ifconfig

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Show Config File Details ###########################
function display_config()
{
	title

	echo 
	echo -e $YELLOW'--->Retrieving Config File Details...'$BLACK
	echo 

	cat /etc/network/interfaces

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Show Ethernet Adapters ###########################
function display_lan()
{
	title

	echo 
	echo -e $YELLOW'--->Retrieving Available LAN Adapter Details...'$BLACK
	echo 

	ifconfig -a | grep 'eth' | awk '{print $5}' > macs

	ifconfig -a | grep 'eth' | awk '{print $1}' > names

	mapfile -t macs < macs

	mapfile -t names < names

	echo -e "---------------------------------"
	echo -e "Name \t MAC"
	echo -e "---------------------------------"

	for((i=0; i < ${#names[@]}; i++));
	do
	        echo -e "${names[i]} \t ${macs[i]}"
	done
	
	echo -e "---------------------------------"
	rm macs names

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Show Ethernet Adapters ###########################
function display_wifi()
{
	title

	echo 
	echo -e $YELLOW'--->Retrieving Available WiFi Adapter Details...'$BLACK
	echo 

	ifconfig -a | grep 'wlan' | awk '{print $5}' > macs

	ifconfig -a | grep 'wlan' | awk '{print $1}' > names

	mapfile -t macs < macs

	mapfile -t names < names

	echo -e "---------------------------------"
	echo -e "Name \t MAC"
	echo -e "---------------------------------"

	for((i=0; i < ${#names[@]}; i++));
	do
	        echo -e "${names[i]} \t ${macs[i]}"
	done
	
	echo -e "---------------------------------"
	rm macs names

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Show WiFi Adapters ###########################
function display_registered_wifi()
{
	title

	echo 
	echo -e $YELLOW'--->Retrieving WiFi Adapter Details...'$BLACK
	echo 

	cat /etc/udev/rules.d/70-persistent-net.rules | grep '{address}' > test

	cat test | grep -o -P '(?<={address}==").*(?=", ATTR{dev_id})' > macs

	cat test | grep -o -P '(?<=NAME=").*(?=")' > names

	mapfile -t macs < macs

	mapfile -t names < names

	echo -e "---------------------------------"
	echo -e "Name \t MAC"
	echo -e "---------------------------------"

	for((i=0; i < ${#names[@]}; i++));
	do
	        echo -e "${names[i]} \t ${macs[i]}"
	done
	
	echo -e "---------------------------------"
	rm macs names test

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Show Primary DNS ###########################
function display_dns()
{
	title

	echo -e "---------------------------------"
	echo -e "    PRIMARY SYSTEM DNS SERVER    "
	echo -e "---------------------------------"

	cat /etc/resolv.conf | grep -o -P '(?<=nameserver ).*(?=)'
		
	echo -e "---------------------------------" $BLACK

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### Run Speed Test ###########################
function speed_test()
{
	title
	echo -e "---------------------------------------"
	echo -e "     MAKING SURE SPEEDTEST IS READY    "
	echo -e "---------------------------------------"
	if [ ! -e /usr/local/bin/speedtest-cli ]; then
    	echo 
    	echo "Installing Speedtest-CLI"
    	echo
    	sudo apt-get install -y python-pip python-dev build-essential
		sudo pip install --upgrade pip
		sudo pip install --upgrade virtualenv
		sudo pip install git+https://github.com/sivel/speedtest-cli
	fi 

	title
	echo -e "---------------------------------"
	echo -e "     TESTING CONNECTION SPEED    "
	echo -e "---------------------------------"
	speedtest --share

	echo
	pause 'Press [Enter] to go back to the Check Network Menu'
	options
	echo
}

########################### START EXECUTION ###########################
options