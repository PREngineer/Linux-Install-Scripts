#!/bin/bash
# Script Name: JUICER installer
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
echo -e $GREEN'Installer'$BLACK

echo
echo "Installing Juicer for Orange Pis"
echo

echo "#!/bin/sh
####################################
# Copyright (C) 2016 by PREngineer #
####################################
#         Auto-Start Juicer        #
####################################
### BEGIN INIT INFO
# Provides:  Juicer
# Short-Description: Juicer upon login
# Description: Juicer is a tool for
# the easy Management of Orange Pis.
### END INIT INFO
####################################

echo -e 'Starting Juicer...'

cd $SCRIPTPATH

sudo ./juicer.sh" > Juicer.sh

sudo chmod ugo+x Juicer.sh

sudo mv Juicer.sh /etc/profile.d/Juicer.sh

echo "Juicer has been installed.  It will load after logging in."

exit 0