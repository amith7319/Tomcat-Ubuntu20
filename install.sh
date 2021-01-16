#!/bin/bash

#User need to be root to run the script
NUM=$(id -u) >/dev/null
if [[ $NUM -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Update the system
apt update -y
apt -y install vim bash-completion wget

#Install Java
read -p "Enter the Jdk verion to be installed:  " JVER
apt install openjdk-$JVER-jdk -y

#Changing Java environment
echo JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
source /etc/environment

#Installing APACHE web server
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
