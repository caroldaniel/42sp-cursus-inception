#!/bin/bash

# Initialize database
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $WP_DATABASE;"
mysql -u root -e "CREATE USER '$WP_USER'@'%' IDENTIFIED BY '$WP_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $WP_DATABASE.* TO '$WP_USER'@'%';"

# Check if dump file exists and import if available
if [ -f /tmp/dump.sql ]; then
    mysql -u root $WP_DATABASE < /tmp/dump.sql
    if [ $? -ne 0 ]; then
        echo "Error: Failed to import dump.sql"
        exit 1
    fi
fi