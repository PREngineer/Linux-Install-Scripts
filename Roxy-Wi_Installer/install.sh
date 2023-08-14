#!/bin/bash

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
echo "Installing HA Proxy..."
echo ""
echo "#######################################"
echo ""
sudo apt-get install haproxy -y

echo "#######################################"
echo ""
echo "Installing Python dependencies..."
echo ""
echo "#######################################"
echo ""
sudo apt-get install apache2 python3 python3-pip python3-ldap python3-requests python3-networkx python3-matplotlib python3-future python3-jinja2 python3-peewee python3-pymysql netcat nmap net-tools rsync ansible lshw dos2unix libapache2-mod-wsgi-py3 -y
sudo apt-get install -y python3-distro
sudo pip3 install pytz 

echo "#######################################"
echo ""
echo "Installing Roxy-Wi..."
echo ""
echo "#######################################"
echo ""

if test /var/www/haproxy-wi
then
    echo "Removing previous installation of Roxy-Wi..."
    sudo rm -r /var/www/haproxy-wi
fi
echo ""
echo "Downloading latest version of Roxy-Wi..."
sudo git clone https://github.com/hap-wi/roxy-wi.git /var/www/haproxy-wi
echo ""
echo "Fixing file permissions..."
sudo chown -R www-data:www-data haproxy-wi
sudo chmod -R 777 haproxy-wi
echo ""
echo "Copying configuration to Apache..."
sudo cp haproxy-wi/config_other/httpd/roxy-wi_deb.conf /etc/apache2/sites-available/roxy-wi.conf
echo ""
echo "Enabling Apache site..."
sudo a2ensite roxy-wi.conf
sudo a2enmod cgid
sudo a2enmod ssl
echo ""
echo "Installing Roxy-Wi dependencies..."
pip3 install -r haproxy-wi/config_other/requirements_deb.txt

echo "#######################################"
echo ""
echo "Restarting Apache..."
echo ""
echo "#######################################"
echo ""
sudo systemctl restart apache2

echo "########################################################"
echo ""
echo "Roxy-Wi for HA Proxy has been successfully installed."
echo ""
IP=$( ifconfig eth0 | grep inet | awk '{print $2}')
echo "Visit the following url to load the user interface:"
echo ""
echo "https://$IP"
echo ""
echo "Use the following credentials to log in:"
echo ""
echo "User: admin"
echo "Pass: admin"
echo ""
echo "########################################################"
