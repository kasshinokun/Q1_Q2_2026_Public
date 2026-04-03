#!/bin/bash

# =========================> IMPORTANT NOTE: <=================================
# Initially, this is in English, 
# but I will add Brazilian Portuguese (my native language) later.
# Thanks for reading
# =============================================================================
# =============================================================================
# Script Name: setter_mysql.sh
# Description: Installs or Updates, and configures MySQL Server 
#              and MySQL Root User on any Linux.
# Author: Gabriel da Silva Cassino
# Date: 2026-04-03 release 20260403 alpha 1c
# =============================================================================

echo "Executing MySQL Secure Installation"
echo "Do you want to run mysql_secure_installation?"
echo "Type: y / Y / Yes / s / S / Sim to proceed"
echo "Any other key will abort the operation."
echo -n "Your choice: "
read -r choice

# Enables case-insensitive matching
shopt -s nocasematch

if [[ "$choice" =~ ^(y|yes|s|sim)$ ]]; then
    sudo mysql_secure_installation
else
    echo "Operation aborted by user."
    exit 0
fi

# Disable (optional, so as not to affect other scripts)
shopt -u nocasematch

echo "Continuing..."

# --- CONFIGURATION ---

# Set the MySQL root password here
read -p "Enter a password for the MySQL root ----->" MYSQL_ROOT_PASSWORD

echo "The password entered was ---> ${MYSQL_ROOT_PASSWORD}"

# --------------------

echo "Updating repositories and installing MySQL..."
sudo apt-get update
sudo apt-get install mysql-server -y

echo "Configuring MySQL..."

# Adjust to ensure the script works on Ubuntu 22.04+ (auth_socket)
# Also changes the authentication method to password (mysql_native_password)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"

sudo mysql -e "FLUSH PRIVILEGES;"

# Executes the secure installation using SQL commands directly to automate the process
# Source: https://stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script
echo "Applying security settings (mysql_secure_installation)..."
sudo mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
DELETE FROM mysql.user WHERE User='';

DROP DATABASE IF EXISTS test;

DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

FLUSH PRIVILEGES;

EOF

echo "MySQL installed and secured successfully."
echo "Root password set: ${MYSQL_ROOT_PASSWORD}"
