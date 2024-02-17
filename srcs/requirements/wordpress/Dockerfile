# Base image
FROM debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG WP_DATABASE
ARG WP_USER
ARG WP_PASSWORD

# Update and upgrade system & install MariaDB client, php-fpm and php-mysql and wget
RUN apt -y update && apt -y upgrade
RUN apt -y install mariadb-client wget php-fpm php-mysql

# Configure PHP so it can communicate with NGINX
RUN sed -i.default \
    "/^listen\s=.*/c\listen = 0.0.0.0:9000" \
    /etc/php/[0-9]*.[0-9]*/fpm/pool.d/www.conf
RUN ln -s $(find /usr/sbin -name 'php-fpm*') /usr/bin/php-fpm

# Expose port
EXPOSE 9000

# Create PID directory for PHP-FPM
RUN mkdir -p /run/php
RUN chmod 755 /run/php

# Copy the initialization script to the container
COPY ./conf/init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod 755 /docker-entrypoint-initdb.d/init.sh

# Run php-fpm
CMD ["php-fpm", "-F"]