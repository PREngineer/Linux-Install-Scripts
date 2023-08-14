#!/bin/bash
# Script Name: Change Network Settings
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

erase=2

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
	echo -e $GREEN'Change Network Settings'$BLACK
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
	echo -e $YELLOW'[01] '$BLACK'Add/Modify - Wireless Configuraton [Static]'
	echo -e $YELLOW'[02] '$BLACK'Add/Modify - Wireless Configuration [DHCP]'
	echo -e $RED'\t- This option will make Ethernet DHCP.'
	echo -e $YELLOW'[03] '$BLACK'Add/Modify - Ethernet Configuration[Static]'
	echo -e $YELLOW'[04] '$BLACK'Add/Modify - Ethernet Configuration[DHCP]'
	echo -e $RED'\t- This option will remove WiFi.'
	echo -e $YELLOW'[05] '$BLACK'Add/Modify - Primary DNS Configuration'
	echo -e $YELLOW'[06] '$BLACK"Disable - WiFi Power Management [Never Off]"
	echo -e $YELLOW'[07] '$BLACK"Enable - WiFi Power Management  [Turns Off]"
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo -e $YELLOW'[99] '$BLACK'Go back to Main Menu'
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo
	echo -e 'Type your choice and press [ENTER]: '

	read option

	case $option in

		1 | 01)
	        add_wifi_static
	        ;;

	    2 | 02)
			add_wifi_dhcp
			;;

	    3 | 03)
	        add_lan_static
	        ;;

	    4 | 04)
			add_lan_dhcp
			;;

	  	5 | 05)
	        change_dns
	        ;;

	    6 | 06)
	        disable_pwr_management
	        ;;

	    7 | 07)
	        enable_pwr_management
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

########################### Create Statis LAN Connection ###########################
function add_lan_static()
{
	display_lan

	########################### Prompt for LAN & MODE ###########################
	go=$true
	while [$go -eq $true];
	do
		echo
		echo -e $BLACK"Which LAN Adapter do you want to configure? [ethX] : "$CYAN
		read eth

		case $eth in

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Got it!  We will be modifying Interface '$eth'."
		       	break
		       	;;
		esac
	done

	# Check that the changes can be applied
	validate

	mode="static"

	########################### Prompt for IP Address ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "An IP Address is the UNIQUE identifier of your device in"
	echo -e "your Network.  It usually is:"
	echo -e "                      192.168.0.x"
	echo -e "                           OR"
	echo -e "                      10.0.0.x"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE AN IP THAT IS NOT ALREADY BEING USED!!"
	echo -e "      USUALLY, IT CANNOT END WITH '.0' or '.255'!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your IP in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Windows PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your IP in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Linux/Mac PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired IP Address : "$CYAN
	read address

	########################### Prompt for Network ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your computer or device is connected to a specific network.  It"
	echo -e "usually is just like your IP but ends with '.0':"
	echo -e "                      192.168.0.0"
	echo -e "                           OR"
	echo -e "                      10.0.0.0"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO PUT THE RIGHT NETWORK!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your NETWORK in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Windows PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your NETWORK in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Linux/Mac PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the Network Address : "$CYAN
	read network

	########################### Prompt for Broadcast ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network has a special IP that is used to establish"
	echo -e "connectivity with new devices.  It is usually like your"
	echo -e "IP but ends with '.255':"
	echo -e "                      192.168.0.255"
	echo -e "                           OR"
	echo -e "                      10.0.0.255"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO PUT THE RIGHT BROADCAST ADDRESS!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your BROADCAST in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network Broadcast IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your BROADCAST in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network Broadcast IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the Broadcast IP Address : "$CYAN
	read broadcast

	########################### Prompt for Mask ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "A Network Mask defines how many computers/devices are allowed"
	echo -e "within your Network.  It usually is:"
	echo -e "                      255.255.255.0"
	echo -e "which represents 254 computers/devices."
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE THE ONE SPECIFIED FOR YOUR NETWORK!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in WINDOWS --"
	echo -e "You can view your local MASK in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in LINUX/MAC OS X --"
	echo -e "You can view your local MASK in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired Network Mask : "$CYAN
	read netmask

	########################### Prompt for Gateway ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network has a device named Router/Gateway.  This"
	echo -e "device is in charge of transferring your data from/to"
	echo -e "the outside world (Internet).  It usually is like"
	echo -e "your IP Address but ends with '.1' like so:"
	echo -e "                      192.168.0.1"
	echo -e "                           OR"
	echo -e "                      10.0.0.1"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE THE ONE SPECIFIED FOR YOUR NETWORK!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in WINDOWS --"
	echo -e "You can view your local MASK in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in LINUX/MAC OS X --"
	echo -e "You can view your local MASK in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired Gateway : "$CYAN
	read gateway

	########################### Prompt for DNS ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network doesn't know all of the internet.  It needs"
	echo -e "an outsider to tell it where to resolve a domain name"
	echo -e "like 'google.com' into an actual IP Address.  This is a"
	echo -e "DNS Server.  You can use multiple DNS Servers.  Just"
	echo -e "separate each one with a space.  You can use public DNS"
	echo -e "servers like Google or Open DNS, or your ISP's.  Like: "
	echo -e " Google:          '8.8.8.8 8.8.4.4'"
	echo -e " OpenDNS: '208.67.222.222 208.67.220.220'"
	echo -e " Mixed:  '208.67.222.222 8.8.8.8 8.8.4.4 208.67.220.220'"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE VALID ADDRESSES!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Figuring Out Your DNS --"
	echo -e "A quick google search will give you your ISP's DNS or"
	echo -e "you can just call them and ask for it."
	echo -e "The Samples for Google and OpenDNS are accurate as of"
	echo -e "the creation of this tool.  Aug/21/2016"
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired DNS Servers : "$CYAN
	read dns

	write_lan_static

	echo -e $YELLOW'--->Restarting Ethernet Network Adapter...'$BLACK
	sudo ifdown $eth
	sudo ifup $eth
}

########################### Create DHCP LAN Connection ###########################
function add_lan_dhcp()
{
	display_lan

	########################### Prompt for LAN & MODE ###########################
	go=$true
	while [$go -eq $true];
	do
		echo
		echo -e $BLACK"Which LAN Adapter do you want to configure? [ethX] : "$CYAN
		read eth

		case $eth in

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Got it!  We will be modifying Interface '$eth'."
		       	break
		       	;;
		esac
	done

	# Check that the changes can be applied
	validate

	mode='dhcp'

	write_lan_dhcp

	echo -e $YELLOW'--->Restarting Ethernet Network Adapter...'$BLACK
	sudo ifdown $eth
	sudo ifup $eth
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
}

########################### Write STATIC LAN To File ###########################
function write_lan_static()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto $eth" >> interfaces
	echo "iface $eth inet $mode" >> interfaces

	if [ "$mode" == "static" ]
	then
		echo "	address $address" >> interfaces
		echo "	netmask $netmask" >> interfaces
		echo "	gateway $gateway" >> interfaces
		echo "	dns-nameservers $dns" >> interfaces
		echo "	broadcast $broadcast" >> interfaces
		echo "	network $network" >> interfaces
	fi

	sudo mv interfaces /etc/network/
}

########################### Write DHCP LAN To File ###########################
function write_lan_dhcp()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto $eth" >> interfaces
	echo "iface $eth inet $mode" >> interfaces

	sudo mv interfaces /etc/network/
}

########################### Create the WiFi Connection ###########################
function add_wifi_static()
{
	display_wifi

	########################### Prompt for WLAN & MODE ###########################
	go=$true
	while [$go -eq $true];
	do
		echo
		echo -e $BLACK"Which Wireless Adapter do you want to configure? [wlanX] : "$CYAN
		read wlan

		case $wlan in

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Got it!  We will be modifying Interface '$wlan'."
		       	break
		       	;;
		esac
	done

	# Check that the changes can be applied
	validate

	mode="static"

	########################### Prompt for IP Address ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "An IP Address is the UNIQUE identifier of your device in"
	echo -e "your Network.  It usually is:"
	echo -e "                      192.168.0.x"
	echo -e "                           OR"
	echo -e "                      10.0.0.x"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE AN IP THAT IS NOT ALREADY BEING USED!!"
	echo -e "      USUALLY, IT CANNOT END WITH '.0' or '.255'!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your IP in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Windows PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your IP in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Linux/Mac PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired IP Address : "$CYAN
	read address

	########################### Prompt for Network ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your computer or device is connected to a specific network.  It"
	echo -e "usually is just like your IP but ends with '.0':"
	echo -e "                      192.168.0.0"
	echo -e "                           OR"
	echo -e "                      10.0.0.0"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO PUT THE RIGHT NETWORK!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your NETWORK in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Windows PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your NETWORK in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Linux/Mac PC's adapter IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the Network Address : "$CYAN
	read network

	########################### Prompt for Broadcast ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network has a special IP that is used to establish"
	echo -e "connectivity with new devices.  It is usually like your"
	echo -e "IP but ends with '.255':"
	echo -e "                      192.168.0.255"
	echo -e "                           OR"
	echo -e "                      10.0.0.255"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO PUT THE RIGHT BROADCAST ADDRESS!!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your BROADCAST in WINDOWS --"
	echo -e "You can view your local range in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network Broadcast IP."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your BROADCAST in LINUX/MAC OS X --"
	echo -e "You can view your local range in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network Broadcast IP."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the Broadcast IP Address : "$CYAN
	read broadcast

	########################### Prompt for Mask ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "A Network Mask defines how many computers/devices are allowed"
	echo -e "within your Network.  It usually is:"
	echo -e "                      255.255.255.0"
	echo -e "which represents 254 computers/devices."
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE THE ONE SPECIFIED FOR YOUR NETWORK!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in WINDOWS --"
	echo -e "You can view your local MASK in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in LINUX/MAC OS X --"
	echo -e "You can view your local MASK in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired Network Mask : "$CYAN
	read netmask

	########################### Prompt for Gateway ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network has a device named Router/Gateway.  This"
	echo -e "device is in charge of transferring your data from/to"
	echo -e "the outside world (Internet).  It usually is like"
	echo -e "your IP Address but ends with '.1' like so:"
	echo -e "                      192.168.0.1"
	echo -e "                           OR"
	echo -e "                      10.0.0.1"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE THE ONE SPECIFIED FOR YOUR NETWORK!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in WINDOWS --"
	echo -e "You can view your local MASK in a Windows PC by opening"
	echo -e "Command Prompt and typing : 'ipconfig /all'.  Your "
	echo -e "current Connection should be listed and you can view "
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo -e "-- Checking your MASK in LINUX/MAC OS X --"
	echo -e "You can view your local MASK in a Linux or Mac OS X PC"
	echo -e "by opening a Terminal and typing 'ifconfig'.  Your"
	echo -e "current Connection should be listed and you can view"
	echo -e "your Network's mask."
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired Gateway : "$CYAN
	read gateway

	########################### Prompt for DNS ###########################
	title
	echo -e $YELLOW"--------------------------------------------------------"
	echo -e "Your network doesn't know all of the internet.  It needs"
	echo -e "an outsider to tell it where to resolve a domain name"
	echo -e "like 'google.com' into an actual IP Address.  This is a"
	echo -e "DNS Server.  You can use multiple DNS Servers.  Just"
	echo -e "separate each one with a space.  You can use public DNS"
	echo -e "servers like Google or Open DNS, or your ISP's.  Like: "
	echo -e " Google:          '8.8.8.8 8.8.4.4'"
	echo -e " OpenDNS: '208.67.222.222 208.67.220.220'"
	echo -e " Mixed:  '208.67.222.222 8.8.8.8 8.8.4.4 208.67.220.220'"
	echo -e "--------------------------------------------------------"
	echo -e $RED"MAKE SURE TO USE VALID ADDRESSES!"$YELLOW
	echo -e "--------------------------------------------------------"
	echo -e "-- Figuring Out Your DNS --"
	echo -e "A quick google search will give you your ISP's DNS or"
	echo -e "you can just call them and ask for it."
	echo -e "The Samples for Google and OpenDNS are accurate as of"
	echo -e "the creation of this tool.  Aug/21/2016"
	echo -e "--------------------------------------------------------"
	echo
	echo -e $BLACK"Enter the desired DNS Servers : "$CYAN
	read dns

	########################### Prompt for Wifi & Password ###########################
	title
	echo -e $RED" ---------------------"
	echo -e "| Watch out for typos!|"
	echo -e " ---------------------"
	echo
	echo -e $BLACK"Enter the Wireless Network Name [ESSID] : "$CYAN
	read wifi
	echo
	echo -e $BLACK"Enter the Wireless Network Password [Passphrase] : "$CYAN
	read pass

	########################### Write To File ###########################

	title
	go=$true
	while [$go -eq $true];
	do
		echo -e $BLACK"What type of connection will you establish? 'WEP' or 'WPA2' : "$CYAN
		read type

		case $type in

			'WEP')
				write_wep_static
				break
				;;

			'WPA2')
				write_wpa2_static
				break
				;;

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Invalid option!  Options are 'WEP' or 'WPA2'."
		       	;;
		esac
	done

	echo -e $YELLOW'--->Restarting Wireless Network Adapter...'$BLACK
	sudo ifdown $wlan
	sudo ifup $wlan
}

########################### Create the WiFi Connection ###########################
function add_wifi_dhcp()
{
	display_wifi

	########################### Prompt for WLAN & MODE ###########################
	go=$true
	while [$go -eq $true];
	do
		echo
		echo -e $BLACK"Which Wireless Adapter do you want to configure? [wlanX] : "$CYAN
		read wlan

		case $wlan in

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Got it!  We will be modifying Interface '$wlan'."
		       	break
		       	;;
		esac
	done

	# Check that the changes can be applied
	validate

	mode="dhcp"

	########################### Prompt for Wifi & Password ###########################
	title
	echo -e $RED" ---------------------"
	echo -e "| Watch out for typos!|"
	echo -e " ---------------------"
	echo
	echo -e $BLACK"Enter the Wireless Network Name [ESSID] : "$CYAN
	read wifi
	echo
	echo -e $BLACK"Enter the Wireless Network Password [Passphrase] : "$CYAN
	read pass

	########################### Write To File ###########################

	title
	go=$true
	while [$go -eq $true];
	do
		echo -e $BLACK"What type of connection will you establish? 'WEP' or 'WPA2' : "$CYAN
		read type

		case $type in

			'WEP')
				write_wep_dhcp
				break
				;;

			'WPA2')
				write_wpa2_dhcp
				break
				;;

			'')
		        echo -e $RED"Please provide a value!"
				;;

		    *)
		       	echo -e $BLACK"Invalid option!  Options are 'WEP' or 'WPA2'."
		       	;;
		esac
	done

	echo -e $YELLOW'--->Restarting Wireless Network Adapter...'$BLACK
	sudo ifdown $wlan
	sudo ifup $wlan
}

function validate()
{
	########################### Retrieved configured devices ###########################
	ifconfig -a | grep 'eth' | awk '{print $1}' > eth
	mapfile -t eths < eth

	ifconfig -a | grep 'wlan' | awk '{print $1}' > wlan
	mapfile -t wlans < wlan

	rm eth wlan

	########################### Prompt for Clear of Config ###########################
	title
	echo -e $BLACK"You have the following Interfaces/Adapters configured:"

	echo -e "--------------"
	echo -e "---Ethernet---"
	for((i=0; i < ${#eths[@]}; i++));
	do
	        echo -e "${eths[i]}"
	done
	echo -e "---Wireless---"
	for((i=0; i < ${#wlans[@]}; i++));
	do
	        echo -e "${wlans[i]}"
	done
	echo -e "--------------"
	echo

	pause 'Press [Enter] to continue...'
}

########################### Write WEP To File ###########################
function write_wep_static()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto eth0" >> interfaces
	echo "iface eth0 inet dhcp" >> interfaces
	echo "" >> interfaces
	echo "auto $wlan" >> interfaces
	echo "allow-hotplug $wlan" >> interfaces
	echo "iface $wlan inet $mode" >> interfaces

	if [ "$mode" == "static" ]
	then
		echo "	address $address" >> interfaces
		echo "	netmask $netmask" >> interfaces
		echo "	gateway $gateway" >> interfaces
		echo "	dns-nameservers $dns" >> interfaces
		echo "	broadcast $broadcast" >> interfaces
		echo "	network $network" >> interfaces
	fi

	echo "	wireless-essid $wifi" >> interfaces
	echo "	wireless-key $pass" >> interfaces
	echo "  wireless-power off" >> interfaces


	sudo mv interfaces /etc/network/
}

########################### Write WPA2 To File ###########################
function write_wpa2_static()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto eth0" >> interfaces
	echo "iface eth0 inet dhcp" >> interfaces
	echo "" >> interfaces
	echo "auto $wlan" >> interfaces
	echo "allow-hotplug $wlan" >> interfaces
	echo "iface $wlan inet $mode" >> interfaces

	if [ "$mode" == "static" ]
	then
		echo "	address $address" >> interfaces
		echo "	netmask $netmask" >> interfaces
		echo "	gateway $gateway" >> interfaces
		echo "	dns-nameservers $dns" >> interfaces
		echo "	broadcast $broadcast" >> interfaces
		echo "	network $network" >> interfaces
	fi
		echo "	wpa-ssid $wifi" >> interfaces
		echo "	wpa-psk $pass" >> interfaces
		echo "  wireless-power off" >> interfaces

	sudo mv interfaces /etc/network/
}

########################### Write WEP To File ###########################
function write_wep_dhcp()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto eth0" >> interfaces
	echo "iface eth0 inet dhcp" >> interfaces
	echo "" >> interfaces
	echo "auto $wlan" >> interfaces
	echo "allow-hotplug $wlan" >> interfaces
	echo "iface $wlan inet $mode" >> interfaces
	echo "	wireless-essid $wifi" >> interfaces
	echo "	wireless-key $pass" >> interfaces
	echo "  wireless-power off" >> interfaces

	sudo mv interfaces /etc/network/
}

########################### Write WPA2 To File ###########################
function write_wpa2_dhcp()
{
	echo "# Network Configuration by Juicer for Orange Pi" > interfaces
	echo "auto lo" >> interfaces
	echo "iface lo inet loopback" >> interfaces
	echo "" >> interfaces
	echo "auto eth0" >> interfaces
	echo "iface eth0 inet dhcp" >> interfaces
	echo "" >> interfaces
	echo "auto $wlan" >> interfaces
	echo "allow-hotplug $wlan" >> interfaces
	echo "iface $wlan inet $mode" >> interfaces
		echo "	wpa-ssid $wifi" >> interfaces
		echo "	wpa-psk $pass" >> interfaces
		echo "  wireless-power off" >> interfaces

	sudo mv interfaces /etc/network/
}

########################### Show WiFi Adapters ###########################
function display_wifi()
{
	title

	echo
	echo -e $YELLOW'--->Retrieving Available WiFi Adapter Details...'$BLACK
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
}

########################### Change Primary DNS ###########################
function change_dns()
{
	########################### Prompt for IP Address ###########################
	title

	echo -e $BLACK"Enter the desired DNS Server : "$CYAN
	read dns
	echo "nameserver $dns" > resolv.conf

	go=$true
	while [$go -eq $true];
	do
		echo -e $BLACK"Add another DNS? [y/n] : "$CYAN
		read another

		case $another in

			'y' | 'Y')
		        echo -e $BLACK"Enter the desired DNS Server : "$CYAN
				read plus
				echo "nameserver $plus" >> resolv.conf
				;;

		    'n' | 'N')
		        echo -e $BLACK"Setting System's Primary DNS..."
		        break
		        ;;

		    *)
		       	echo -e $RED"Invalid Option.  Enter 'y' or 'n' and press [ENTER]: "$BLACK
		esac
	done

	sudo mv resolv.conf /etc/
}

########################### Disable WiFi Power Management ###########################
function disable_pwr_management()
{
	echo
	echo -e $YELLOW'--> Disabling WiFi Power Management...'
	echo

	ifconfig -a | grep 'wlan' | awk '{print $1}' > names

	mapfile -t names < names

	rm names

	if [ ! -d "/etc/pm/power.d" ]
	then
		sudo mkdir /etc/pm
		sudo mkdir /etc/pm/power.d
	fi

	if [ ! -e "/etc/pm/power.d/wifi_pwr_off" ]
	then
		echo "#!/bin/sh" > wifi_pwr_off
		echo "/sbin/iwconfig ${names[0]} power off" >> wifi_pwr_off

		sudo chmod +x wifi_pwr_off

		sudo mv wifi_pwr_off /etc/pm/power.d/

		echo
		echo -e $RED"WiFi Power Management has been Disabled!"$BLACK
		echo

		pause 'Press [Enter] to Restart...'
		sudo reboot now
	else
		echo
		echo -e $RED"WiFi Power Management is already Disabled!"$BLACK
		echo

		pause 'Press [Enter] to Continue...'
		options
	fi
}

########################### Enable WiFi Power Management ###########################
function enable_pwr_management()
{
	echo
	echo -e $YELLOW'--> Enabling WiFi Power Management...'
	echo

	if [ -e "/etc/pm/power.d/wifi_pwr_off" ]
	then
		rm /etc/pm/power.d/wifi_pwr_off

		echo
		echo -e $RED"WiFi Power Management has been Enabled!"$BLACK
		echo

		pause 'Press [Enter] to Restart...'
		sudo reboot now
	else
		echo
		echo -e $RED"WiFi Power Management is already Enabled!"$BLACK
		echo

		pause 'Press [Enter] to continue...'
		options
	fi
}

########################### START EXECUTION ###########################

options


########################### Restarting Network Services ###########################

echo
echo -e $YELLOW'--->Restarting Network Services...'$BLACK
sudo /etc/init.d/networking restart
echo
echo -e $GREEN'--->All done. '$BLACK

options
echo -e $GREEN"Changes were applied."

exit 0
