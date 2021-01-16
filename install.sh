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


#Installing Postgress 13
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
apt update -y
apt install postgresql-13 postgresql-client-13
systemctl start postgresql.service
systemctl enable postgresql.service
POSTGRESPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
su - postgres
psql -c "alter user postgres with password '$POSTGRESPASSWORD'"
echo Postgres user password = $POSTGRESPASSWORD >> /root/password.txt


#Installing PgAdmin
apt install pgadmin4 pgadmin4-apache2 -y
