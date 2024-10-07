#!/bin/bash

# # !/bin/bash
set -e
# Start MariaDB service
service mysql start

sleep 5
# If first run, initialize the database
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  # mysql_install_db --user=mysql > /dev/null

  # Create user and database if they don't exist, using root password
  mysql  <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
EOSQL

  # Secure installation by setting root password
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown

# Keep MySQL alive
exec "$@"
