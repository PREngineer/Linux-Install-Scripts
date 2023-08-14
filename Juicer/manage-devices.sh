#!/bin/bash
# Script Name: manage-devices.sh
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
	echo -e $GREEN'Manage Devices'$BLACK
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

  echo
  echo -e '-----------------------------------------------------------------------------------------------------------'
  echo -e $BLACK'AVAILABLE\t'$CYAN'NOT AVAILABLE YET'$BLACK
  echo -e '-----------------------------------------------------------------------------------------------------------'
  echo -e
	echo -e $YELLOW'@---@---@---@---@---@--- CHOOSE ---@---@---@---@---@---@'
	echo -e $YELLOW'[01] '$BLACK"Install USB Auto Mounter"
	echo -e $YELLOW'[02] '$BLACK"Uninstall USB Auto Mounter"
	echo -e $YELLOW'[03] '$BLACK"Show My Drives"
	echo -e $YELLOW'[04] '$CYAN"Fix USB Drive Permissions 		[If you can't write]"
	echo -e $YELLOW'[05] '$CYAN"Safely Remove/Eject USB Drive	[Don't just pull]"
	echo -e $YELLOW'[06] '$BLACK''
	echo -e $YELLOW'[07] '$BLACK''
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo -e $YELLOW'[99] '$BLACK'Exit - Go back to Main Menu'
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo
	echo -e $BLACK'Type your choice and press [ENTER]: '

	read option

	case $option in

		1 | 01)
          echo
          sudo apt-get install -y usbmount
          echo
        	pause 'Press [Enter] to go back to the Manage Devices Menu'
        	options
        	echo
	        ;;

	    2 | 02)
          echo
	        sudo apt-get remove -y usbmount
	        sudo apt-get purge -y usbmount
          echo
        	pause 'Press [Enter] to go back to the Manage Devices Menu'
        	options
        	echo
	        ;;

	    3 | 03)
	        show_drives
	        ;;

	    4 | 04)
	        fix_permissions
	        ;;

	  	5 | 05)
	        eject_drive
	        ;;

	  	6 | 06)

	        ;;

	   	7 | 07)

	        ;;

	    8 | 08)

	        ;;

	    99 | 99)
			cd $SCRIPTPATH
			sudo ./juicer.sh
			exit 0
	        ;;

	    *)
	       	echo -e $RED'Invalid Option!  Try again...'$BLACK
			options
	esac
}

########################### SHOW USB DRIVES ###########################
function show_drives()
{
  title

  echo -e
  echo -e $GREEN'mmcblk = Micro SD'$CYAN' | Other = USB'
  echo -e
  echo -e $BLACK'Drive\t\tSpace Used  Avail %Use Mount Point'
	echo -e '-----------------------------------------------'
	df -h | grep '/dev/'
	echo -e '-----------------------------------------------'

  echo
	pause 'Press [Enter] to go back to the Manage Devices Menu'
	options
	echo
}

###########################  ###########################
#function fix_permissions(){}

###########################  ###########################
#function eject_drive(){}

###########################  ###########################
#function empty(){}

########################### Start Execution ###########################
options
