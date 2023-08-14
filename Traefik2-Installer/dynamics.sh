#!/bin/bash
#################################################################
# Script Name: Traefik V2 Helper Script
# Author: PREngineer (Jorge Pabon) - pianistapr@hotmail.com
# Publisher: Jorge Pabon
# License: Personal Use (1 device)
#################################################################

echo
echo '████████╗██████╗  █████╗ ███████╗███████╗██╗██╗  ██╗    ██╗   ██╗██████╗ '
echo '╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██╔════╝██║██║ ██╔╝    ██║   ██║╚════██╗'
echo '   ██║   ██████╔╝███████║█████╗  █████╗  ██║█████╔╝     ██║   ██║ █████╔╝'
echo '   ██║   ██╔══██╗██╔══██║██╔══╝  ██╔══╝  ██║██╔═██╗     ╚██╗ ██╔╝██╔═══╝ '
echo '   ██║   ██║  ██║██║  ██║███████╗██║     ██║██║  ██╗     ╚████╔╝ ███████╗'
echo '   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝      ╚═══╝  ╚══════╝'
echo '                                             Brought to you by PREngineer'
echo

echo
echo  "╔═════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
echo  '║ 1. This script has been written and tested for ARM v6 raspberry Pis.                                    ║'
echo  '║ 2. The author(s) cannot be held accountable for any problems that might occur if you run this script.   ║'
echo  '║ 3. Proceed only if you authorize this tool to make changes to your system.                              ║'
echo  '║═════════════════════════════════════════════════════════════════════════════════════════════════════════║'
echo  '║        CONTINUE TO AGREE.  OTHERWISE PRESS    [ C T R L   +   C ]                                       ║'
echo  '╚═════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
echo

echo "-----------------------------------------------------------------------------------"
read -p "Do you want to create a new Dynamic Configuration for a host? [Y/N]: " NEWCONFIG
echo "-----------------------------------------------------------------------------------"

while [ $NEWCONFIG == 'Y' ] || [ $NEWCONFIG == 'y' ]
do
    read -p "Please provide the Service's Name (No Spaces) [ example: TravelBlog ]: " SERVICENAME
    read -p "Please provide the URL of the subdomain to listen for [ example: blog.travel.com ]: " URL
    read -p "Please provide the URL of the backend server: [ example: http://<ip> or http://<ip>:<port> ] " BACKEND

echo "#################################
# $SERVICENAME Dynamic Configuration
#################################

# Definition on how to handle HTTP requests
http:

  # Define the routers
  routers:

    # Map to Service without entry points defined so that it listens in all of them
    $SERVICENAME:
      rule: \"Host(\`$URL\`)\"
      service: $SERVICENAME
      tls:
        certResolver: letsencrypt

  # Define the services
  services:

    # Service
    $SERVICENAME:
      loadBalancer:
        # Backend URLs
        servers:
        - url: \"$BACKEND\"" > $SERVICENAME.yaml


    read -p "Do you need to add another backend url (for load balancing) ? [Y/N] " ADD

    while [ $ADD == 'Y' ] || [ $ADD == 'y' ]
    do
      read -p "Please provide the URL of the additional backend server: " BACKEND
      echo "        - url: \"$BACKEND\"" >> $SERVICENAME.yaml
      read -p "Do you need to add another backend url (for load balancing) ? [Y/N] " ADD
    done
    mv $SERVICENAME.yaml /etc/traefik/dynamics/
    
    echo "-----------------------------------------------------------------------------------"
    read -p "Do you want to create a new Dynamic Configuration for a host? [Y/N]: " NEWCONFIG
    echo "-----------------------------------------------------------------------------------"
done
