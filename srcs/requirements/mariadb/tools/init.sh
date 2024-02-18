#!/bin/bash

service mariadb start

# Create WordPress database
mariadb -u root -p "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mariadb -u root -p "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -u root -p "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';"
mariadb -u root -p "FLUSH PRIVILEGES;"

# Set password for root user
mariadb -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');"
mariadb -u root -p "FLUSH PRIVILEGES;"

# Allow root user to login from any host
mariadb -u root -p $MYSQL_ROOT_PASSWORD "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mariadb -u root -p $MYSQL_ROOT_PASSWORD "FLUSH PRIVILEGES;"

# Check if dump file exists and import if available
if [ -f /tmp/dump.sql ]; then
    mysql -u root $MYSQL_DATABASE < /tmp/dump.sql
    if [ $? -ne 0 ]; then
        echo "Error: Failed to import dump.sql"
        exit 1
    fi
fi

service mariadb stop