#!/bin/bash

##################  MANDATORY  ##################

# Donwload and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mkdir -p /var/www/html/
mv wordpress/* /var/www/html/
rm -rf latest.tar.gz

# Configure WordPress config with database information
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/$MYSQL_DATABASE/g" /var/www/html/wp-config.php
sed -i "s/username_here/$MYSQL_USER/g" /var/www/html/wp-config.php
sed -i "s/password_here/$MYSQL_PASSWORD/g" /var/www/html/wp-config.php
sed -i "s/localhost/$MYSQL_HOSTNAME:3306/g" /var/www/html/wp-config.php

# Change ownership of WordPress files
chown -R www-data:www-data /var/www/html/

##################  BONUS  ##################

# Redis Cache

echo -e "\n\
################## Redis Cache ##################\n\
define('WP_CACHE', true);\n\
define('WP_REDIS_HOST', 'redis');\n\
define('WP_REDIS_PORT', '6379');\n\
define('WP_REDIS_TIMEOUT', 1);\
" | tee -a /var/www/html/wp-config.php