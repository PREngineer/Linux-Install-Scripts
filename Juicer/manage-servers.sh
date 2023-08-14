#!/bin/bash
# Script Name: manage-servers.sh
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
	echo -e $GREEN'Servers/Services'$BLACK
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
  echo -e $YELLOW'[] '$CYAN'Web Server 		[Host your own webpages]'
  echo -e $YELLOW'[] '$CYAN'Database Server 	[Host your own databases]'
  echo -e $YELLOW'[] '$CYAN'Mail Server 		[Host your own mail]'
  echo -e $YELLOW'[] '$CYAN'Printer Server 	[Manage your printers]'
  echo -e $YELLOW'[] '$CYAN'Cloud Server 	[Host your own Dropbox]'
  echo -e $YELLOW'[] '$CYAN'Git Server 		[Host your own GitHub]'
  echo -e $YELLOW'[] '$CYAN'VPN Server 		[Host your own VPN]'
  echo -e $YELLOW'[] '$CYAN'FTP Server 		[Host your own file server]'
  echo -e $YELLOW'[] '$CYAN'Plex Media Server	[Stream videos to devices]'
  echo -e $YELLOW'[] '$CYAN'Jenkins CI Server	[Your own Continuous Integration]'
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo -e $YELLOW'[99] '$BLACK'Exit - Go back to Main Menu'
	echo -e $YELLOW'@---@---@---@---@---@--------------@---@---@---@---@---@'
	echo
	echo -e $BLACK'Type your choice and press [ENTER]: '

	read option

	case $option in

		1 | 01)
          echo

          echo
        	pause 'Press [Enter] to go back to the Manage Devices Menu'
        	options
        	echo
	        ;;

	    2 | 02)
          echo

          echo
        	pause 'Press [Enter] to go back to the Manage Devices Menu'
        	options
        	echo
	        ;;

	    3 | 03)

	        ;;

	    4 | 04)

	        ;;

	  	5 | 05)

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

###########################  ###########################
#function empty(){}

########################### Start Execution ###########################
options
