# Base image
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         MYSQL_DATABASE
ARG         MYSQL_USER
ARG         MYSQL_PASSWORD
ARG         MYSQL_HOSTNAME

# Update and upgrade system & install MariaDB client, php-fpm and php-mysql and wget
RUN         apt -y update && apt -y upgrade
RUN         apt -y install wget php7.4-fpm php7.4-mysql mariadb-client

##################  BONUS  ##################
# Redis Cache
RUN         apt -y install php7.4-redis redis-tools

# Configure PHP so it can communicate with NGINX
RUN         mv /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.default
COPY        ./conf/www.conf /etc/php/7.4/fpm/pool.d/
RUN         ln -s $(find /usr/sbin -name 'php-fpm*') /usr/bin/php-fpm

# Expose port
EXPOSE      9000

# Create PID directory for PHP-FPM
RUN         mkdir -p /run/php
RUN         chmod 755 /run/php

# Execute Wordpress Initialization script
COPY        ./tools/init.sh /usr/local/bin/
RUN         bash /usr/local/bin/init.sh

# Copy Wordpress customized content
RUN         mkdir -p /var/www/html/wp-content/uploads/2024/02/
COPY        ./conf/uploads/* /var/www/html/wp-content/uploads/2024/02/
RUN         chmod -R 755 /var/www/html/wp-content/uploads/
RUN         chmod 644 /var/www/html/wp-content/uploads/2024/02/*
RUN         chown -R www-data:www-data /var/www/html/wp-content/uploads/

# Run php-fpm
ENTRYPOINT  [ "php-fpm", "-F" ]