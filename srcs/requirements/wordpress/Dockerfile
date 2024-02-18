# Base image
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         MYSQL_DATABASE
ARG         MYSQL_USER
ARG         MYSQL_PASSWORD

# Update and upgrade system & install MariaDB client, php-fpm and php-mysql and wget
RUN         apt -y update && apt -y upgrade
RUN         apt -y install wget php7.4-fpm php7.4-mysql

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

# Run php-fpm
ENTRYPOINT  [ "php-fpm", "-F" ]