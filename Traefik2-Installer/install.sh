#!/bin/bash
#################################################################
# Script Name: Traefik V2 Installer
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

echo "#######################################"
echo ""
echo "Grabbing operating system details..."
echo ""
echo "#######################################"
echo ""
sudo apt-get update --allow-releaseinfo-change -y

echo "#######################################"
echo ""
echo "Updating operating system..."
echo ""
echo "#######################################"
echo ""
sudo apt-get upgrade -y

echo "#######################################"
echo ""
echo "Setting up directories..."
echo ""
echo "#######################################"
echo ""
mkdir /etc/traefik
mkdir /etc/traefik/dynamics
touch /etc/traefik/traefik.yaml
touch /etc/traefik/acme.json
chmod 0600 /etc/traefik/acme.json
chmod 0600 /etc/traefik/traefik.yaml

echo "#######################################"
echo ""
echo "Grabbing latest ARMv6 Traefik binaries from GitHub..."
echo ""
echo "#######################################"
echo ""
# Get the latest version from the github releases
curl https://github.com/traefik/traefik/releases | grep '/traefik/traefik/releases/download' | grep 'linux_armv6.tar.gz' | awk '{print $2}' > url.txt
url=$(head -n 1 url.txt)
url=${url:6}
url=${url::-1}

# Set the URL to download
url="https://github.com"$url

# Actually download it
wget $url
rm url.txt

# Identify the file name to extract
file="$(basename $url)"

# Extract file
tar -xvzf $file

# Clean up unnecessary stuff
rm CHANGELOG.md LICENSE.md traefik_v2.5.6_linux_armv6.tar.gz
chmod +x traefik
mv traefik /usr/local/bin/

echo "#######################################"
echo ""
echo "Creating Static configuration file..."
echo ""
echo "#######################################"
echo ""

echo '#################################
# Traefik V2 Static Configuration
#################################

# Global Configurations
global:
  # Check for Update
  checkNewVersion: true

# Configure the transport between Traefik and your servers
serversTransport:
  # Skip the check of server certificates
  insecureSkipVerify: true

# Configure the network entrypoints into Traefik V2. Which port will receive packets and if TCP/UDP
entryPoints:

  # HTTP Entry Point
  web:
    # Listen on TCP port 80  (80/tcp)
    address: ":80"
    # redirect http to https
    http:
      redirections:
        entryPoint:
          # Where to redirect
          to: web-secure
          # Scheme to use
          scheme: https
          # Make it always happen
          permanent: true

  # HTTPS Entry Point
  web-secure:
    # Listen on TCP port 443  (443/tcp)
    address: ":443"
    # Define TLS with Lets Encrypt for all
    http:
      tls:
        certResolver: letsencrypt

# Configure the providers
providers:
  # If using a dynamic file
  file:
    directory: "/etc/traefik/dynamics"
    watch: true

  rest:
    insecure: true

# Traefiks Dashboard located in http://<ip>/dashboard/ (last / necessary)
api:
  # Enable the dashboard
  dashboard: true

# Location of Log files
log:
  # Logging levels are: DEBUG, PANIC, FATAL, ERROR, WARN, INFO
  level: ERROR
  filePath: "/etc/traefik/traefik.log"

# SSL Certificates
certificatesResolvers:
# Use Lets Encrypt for SSL Certificates
  letsencrypt:
    # Enable ACME (Lets Encrypt automatic SSL)
    acme:
      # E-mail used for registration
      email: "email@hotmail.com"
      # Leave commented for PROD servers uncomment for Non Prod
      #caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
      # File or key used for certificates storage.
      storage: "/etc/traefik/acme.json"

      # Use HTTP-01 ACME challenge
      httpChallenge:
        entryPoint: web-secure' > /etc/traefik/traefik.yaml

echo "#######################################"
echo ""
echo "Creating Dynamic configuration file..."
echo ""
echo "#######################################"
echo ""

echo '#################################
# Traefik V2 Dynamic Configuration
#################################

# Definition on how to handle HTTP requests
http:

  # Define the routers
  routers:

    # Map Traefik Dashboard requests to the Service
    Traefik:
      middlewares:
      - BasicAuth
      rule: "Host(`traefik.jlpc.dns1.us`)"
      service: api@internal
      tls:
        certResolver: letsencrypt

  # Define the middlewares
  middlewares:
    # Basic auth for the dashboard
    BasicAuth:
      basicAuth:
        # Specify user and password (generator: https://www.web2generators.com/apache-tools/htpasswd-generator)
        users:
          - "admin:$apr1$g69ls4e3$t3HJCG2MxjJf36Zno879h/"' > /etc/traefik/dynamics/traefik.yaml

echo "#######################################"
echo ""
echo "Setting up as a service..."
echo ""
echo "#######################################"
echo ""

echo '[Unit]
Description=Traefik
Documentation=https://docs.traefik.io
After=network-online.target
AssertFileIsExecutable=/usr/local/bin/traefik
AssertPathExists=/etc/traefik
[Service]
Type=notify
ExecStart=/usr/local/bin/traefik -c /etc/traefik/traefik.yaml
Restart=always
WatchdogSec=1s
ProtectSystem=strict
ReadWritePaths=/etc/traefik/acme.json
ReadOnlyPaths=/etc/traefik/traefik.yaml
PrivateTmp=true
ProtectHome=true
PrivateDevices=true
ProtectKernelTunables=true
ProtectControlGroups=true
LimitNPROC=1
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/traefik.service;

echo "########################################################"
echo ""
echo "Enabling Traefik v2 service..."
echo ""
echo "########################################################"
systemctl daemon-reload
systemctl enable traefik.service
systemctl start traefik.service

echo "#######################################"
echo ""
echo "Creating additional Dynamic configuration file(s)..."
echo ""
echo "#######################################"
echo ""

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
