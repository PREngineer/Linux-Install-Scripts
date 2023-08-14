#!/bin/bash
# Script Name: JUICER uninstaller
# Author: PREngineer (Jorge Pabon) - pianistapr@hotmail.com
# Publisher: Jorge Pabon
# License: Personal Use (1 device)
###########################################################

function pause()
{
   read -p "$*"
}

# Color definition variables
YELLOW='\e[33;3m'
RED='\e[91m'
BLACK='\033[0m'
CYAN='\e[96m'
GREEN='\e[92m'

SCRIPTPATH=$(pwd)

# Display the Title Information
clear
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
echo -e $GREEN'Uninstaller'

echo
echo -e $RED"Are you sure that you want to uninstall Juicer for Orange Pis?"
echo -e $YELLOW"Press 'y' to uninstall or 'n' to go back to the Main Menu : "$CYAN
read option
echo

case $option in

	'y' | 'Y')
		echo
		echo -e $YELLOW"-->Uninstalling Juicer for Orange Pis..."
		echo

		if [ ! -e "/etc/profile.d/Juicer.sh" ]
		then
			echo -e $RED"Juicer for Orange Pis has already been uninstalled!"$BLACK
		else
			sudo rm /etc/profile.d/Juicer.sh
			echo -e $GREEN"Done!"
			echo
			echo "A Reboot is necessary to apply the changes."
			echo
			pause 'Press [ENTER] to continue...'

			sudo reboot now
		fi

		exit 0
		;;

	'n' | 'N')
		sudo ./juicer.sh
		;;

	*)
		echo -e $RED"Invalid Option.  Try again!"
		sudo ./uninstaller.sh
		;;
esac
