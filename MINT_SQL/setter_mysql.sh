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
# Date: 2026-04-03 release 20260403 alpha 1d
# =============================================================================

setting_user(){

    # --- CONFIGURATION ---
    # Set the MySQL root password here

    # Reads the password hidden - Recommended
    # read -s -p "Enter a password for MySQL root: " MYSQL_ROOT_PASSWORD

    # For visual user feedback
    read -p "Enter a password for MySQL root: " MYSQL_ROOT_PASSWORD
    echo

    # Reads password confirmation hidden - Recommended
    # read -s -p "Confirm the password: " MYSQL_ROOT_PASSWORD_CONFIRM

    # For visual user feedback
    read -p "Confirm the password: " MYSQL_ROOT_PASSWORD_CONFIRM
    echo
    if [[ "$MYSQL_ROOT_PASSWORD" != "$MYSQL_ROOT_PASSWORD_CONFIRM" ]]; then
        echo "Passwords do not match. Aborting."
        return 1
    fi
    # For visual user feedback
    echo "The entered password is --->  ${MYSQL_ROOT_PASSWORD}"
    # --------------------
    # Escapes single quotes in the password for SQL usage (basic)
    local escaped_pass="${MYSQL_ROOT_PASSWORD//\'/\\\'}"

    echo "Updating repositories and installing MySQL..."
    sudo apt-get update || { echo "Update failed"; return 1; }
    sudo apt-get install mysql-server -y || { echo "Installation failed"; return 1; }

    # Ensures the service is running
    sudo systemctl start mysql
    sudo systemctl enable mysql

    echo "Configuring MySQL..."

    # ==========================================================================> Previous pattern
    # Adjustment to ensure the script works on Ubuntu 22.04+ (auth_socket)
    # Also changes authentication method to password (mysql_native_password)
    # sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
    # sudo mysql -e "FLUSH PRIVILEGES;"

    # ==========================================================================> Current pattern
    # Changes plugin and password in a single command (using initial auth_socket)
    sudo mysql <<EOF
        ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${escaped_pass}';
        FLUSH PRIVILEGES;
EOF


    # Runs secure installation using SQL commands directly to automate
    # Source: https://stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script
    echo "Applying security settings (mysql_secure_installation)..."
    sudo mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
EOF
    if [[ $? -eq 0 ]]; then
        echo "MySQL successfully installed and secured."
        # echo "Root password set: ${MYSQL_ROOT_PASSWORD}" # Visual feedback
        echo "Root password set."
    else
        echo "There was an error in the security settings."
        return 1
    fi
}


main(){
    echo "Executing MySQL Secure Installation"
    echo "Do you want to run mysql_secure_installation?"
    echo "Type: y / Y / Yes / s / S / Sim to proceed"
    echo "Any other key will abort the operation."
    echo -n "Your choice: "
    read -r choice

    # Enables case-insensitive matching
    shopt -s nocasematch

    if [[ "$choice" =~ ^(y|yes|s|sim)$ ]]; then
        echo "Initializing MySQL Secure Installation"
        # sudo mysql_secure_installation
        echo "Process completed."
    else
        echo "Operation aborted by user."
        exit 0
    fi

    # Disable (optional, so as not to affect other scripts)
    shopt -u nocasematch

    echo "Continuing..."

    setting_user
}


main
