#!/bin/bash

# Donwload and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress /var/www/html/
rm -rf latest.tar.gz

# Configure WordPress config with database information
sed -i "s/database_name_here/$WP_DATABASE/g" /var/www/html/wordpress/wp-config-sample.php
sed -i "s/username_here/$WP_USER/g" /var/www/html/wordpress/wp-config-sample.php
sed -i "s/password_here/$WP_PASSWORD/g" /var/www/html/wordpress/wp-config-sample.php
mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Change ownership of WordPress files
chown -R www-data:www-data /var/www/html/wordpress
