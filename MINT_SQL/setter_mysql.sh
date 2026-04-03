#!/bin/bash

# --- CONFIGURAÇÃO ---
# Defina a senha do root do MySQL aqui
read -p  "Digite uma senha para o root do MySQL----->" MYSQL_ROOT_PASSWORD

echo "a senha escrita foi --->  ${MYSQL_ROOT_PASSWORD}"
# --------------------

echo "Atualizando repositórios e instalando MySQL..."
sudo apt-get update
sudo apt-get install mysql-server -y

echo "Configurando o MySQL..."

# Ajuste para garantir que o script funcione no Ubuntu 22.04+ (auth_socket)
# Também altera o método de autenticação para senha (mysql_native_password)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Executa o secure installation usando comandos SQL diretamente para automatizar
# Fonte: https://stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script
echo "Aplicando configurações de segurança (mysql_secure_installation)..."
sudo mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo "MySQL instalado e securizado com sucesso."
echo "Senha root definida: ${MYSQL_ROOT_PASSWORD}"

