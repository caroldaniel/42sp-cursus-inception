#!/bin/bash

service mariadb start

# Install MariaDB
mysql_secure_installation << _EOF_

Y
1234root4321
1234root4321
Y
n
Y
Y
_EOF_

# Grant root access to MariaDB
mariadb -e "GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mariadb -e "FLUSH PRIVILEGES;"

# Create WordPress database
mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';"
mariadb -e "FLUSH PRIVILEGES;"

# Check if dump file exists and import if available
if [ -f /tmp/dump.sql ]; then
    mysql -u root $MYSQL_DATABASE < /tmp/dump.sql
    if [ $? -ne 0 ]; then
        echo "Error: Failed to import dump.sql"
        exit 1
    fi
fi

service mariadb stop