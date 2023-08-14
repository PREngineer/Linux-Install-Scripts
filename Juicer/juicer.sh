#!/bin/bash
# Script Name: JUICER for Orange Pi
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

# Make sure all Scripts in this folder are executable
sudo chmod -R 775 * >/dev/null 2>&1

function pause()
{
   read -p "$*"
}

if [ "$EUID" -ne 0 ]
  then
  echo
  echo -e $RED'Please run as root using the command: '$BLACK'sudo ./juicer.sh'
  echo
  exit 0
fi

# Make sure to clear the Terminal
clear

# Get the internal IP Address
LocalIP=$(hostname -I)

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
echo -e $GREEN'Main Menu'$BLACK
echo
echo -e "╔═════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
echo -e '║'$RED' 1. This tool has been tested on Ubuntu (Server & Desktop).'$BLACK'                                              ║'
echo -e '║'$RED' 2. The author(s) cannot be held accountable for any problems that might occur if you run this tool.'$BLACK'     ║'
echo -e '║'$RED' 3. Proceed only if you authorize this tool to make changes to your system.'$BLACK'                              ║'
echo -e '║═════════════════════════════════════════════════════════════════════════════════════════════════════════║'
echo -e '║'$RED'        CONTINUE TO AGREE.  OTHERWISE PRESS    [ C T R L   +   C ]'$BLACK'                                       ║'
echo -e '╚═════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
echo
echo -e '-----------------------------------------------------------------------------------------------------------'
echo -e $BLACK'AVAILABLE\t'$CYAN'NOT AVAILABLE YET'$BLACK'\t\t\t\t\t\t'Pi IP Address: $LocalIP
echo -e '-----------------------------------------------------------------------------------------------------------'
echo -e
echo -e $YELLOW'@---@---@---@---@---@--- UPDATE ---@---@---@---@---@---@'
echo -e $YELLOW'[00] '$BLACK'Update Juicer for Orange Pis'
echo -e $YELLOW'[01] '$BLACK'Uninstall Juicer for Orange Pis'
echo -e $YELLOW'[02] '$BLACK'Update System'
echo
echo -e $YELLOW'@---@---@---@---@---@--- NETWORK ---@---@---@---@---@---@'
echo -e $YELLOW'[03] '$BLACK'Check Network Settings'
echo -e $YELLOW'[04] '$BLACK'Change Network Settings'
echo
echo -e $YELLOW'@---@---@---@---@---@--- DEVICES & PARTITIONS ---@---@---@---@---@---@'
echo -e $YELLOW'[05] '$BLACK'Manage Devices'
echo -e $YELLOW'[06] '$CYAN'Manage Partitions'
echo
echo -e $YELLOW'@---@---@---@---@---@--- NETWORK STORAGE---@---@---@---@---@---@'
echo -e $YELLOW'[07] '$CYAN'Manage File Shares'
echo -e $YELLOW'[08] '$CYAN'Manage Mount Points'
echo
echo -e $YELLOW'@---@---@---@---@---@--- SERVERS/SERVICES ---@---@---@---@---@---@'
echo -e $YELLOW'[09] '$BLACK'Manage Servers'
echo
echo -e $YELLOW'@---@---@---@---@---@--- P2P/SHARING ---@---@---@---@---@---@'
echo -e $YELLOW'[] '$CYAN'Usenet Indexer	[Host your own OzNZB]'
echo -e $YELLOW'[] '$CYAN'Torrent Indexer	[Host your own Kickass]'
echo
echo -e $YELLOW'@---@---@---@---@---@--- Automation ---@---@---@---@---@---@'
echo -e $YELLOW'[] '$CYAN'Media Downloader	[Automatically download TV, Movies, etc.]'
echo
echo -e $YELLOW'@---@---@---@---@---@--- CLIENT ROLES ---@---@---@---@---@---@'
echo -e $YELLOW'[] '$CYAN'Kodi Media Player	[]'
echo -e $YELLOW'[] '$CYAN' Server 		[]'
echo
echo -e $YELLOW'@---@---@---@---@---@--- SOFTWARE ---@---@---@---@---@---@'
echo -e $YELLOW'[] '$CYAN'Wordpress	 	[Content Management System for Web]'
echo -e $YELLOW'[] '$CYAN'Joomla 		[Content Management System for Web]'
echo
echo -e $YELLOW'@---@---@---@---@---@--- GAMES ---@---@---@---@---@---@'
echo -e $YELLOW'[] '$CYAN'Minecraft Server	[Host your own Minecraft]'
echo
echo -e $YELLOW'@---@---@---@---@---@--- QUIT ---@---@---@---@---@---@'
echo -e $YELLOW'[98] '$BLACK'Restart Orange Pi  [Sometimes necessary after changes]'
echo -e $YELLOW'[99] '$BLACK'Quit'

echo
echo -n "Choose your action [00-99]: "
read option

case $option in

	0 | 00)
		echo
	    echo -e $YELLOW'--->Checking for updates...'$BLACK
		git reset --hard
		git pull
		sudo chmod -R 775 * >/dev/null 2>&1
		echo
		pause 'Press [Enter] to restart and continue...'
		cd $SCRIPTPATH
		sudo ./juicer.sh
		exit 0
		;;

	1 | 01)
    sudo ./uninstaller.sh
    ;;

	2 | 02)
    echo -e $YELLOW'--->Updating Operating System Data...'$BLACK
    sudo apt-get update -y
    echo -e $YELLOW'--->Upgrading Operating System...'$BLACK
    sudo apt-get upgrade -y
    sudo ./juicer.sh
    exit 0
    ;;

  3 | 03)
    sudo ./check-network-settings.sh
    ;;

  4 | 04)
    sudo ./change-network-settings.sh
    ;;

  5 | 05)
    sudo ./manage-devices.sh
    ;;

  9 | 09)
    sudo ./manage-servers.sh
    ;;

  98)
    sudo reboot now
    ;;

  99)
    exit 0
    ;;

  *)
    echo -e $RED'Invalid Option'$BLACK
		ScriptLoc=$(readlink -f "$0")
		sleep 1
		exec $ScriptLoc
esac
