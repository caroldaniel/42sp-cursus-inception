#!/bin/bash

# Enable Redis Cache after Database is ready
while ! wp db check --allow-root --path=/var/www/html/; do
    echo "Waiting for Database to be ready..."
    sleep 1
done
wp plugin install redis-cache --activate --allow-root --path=/var/www/html/
wp redis enable --allow-root --path=/var/www/html/

# Start php-fpm
php-fpm -F