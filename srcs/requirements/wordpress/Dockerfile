# Base image
FROM debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG WP_DATABASE
ARG WP_USER
ARG WP_PASSWORD

# Update and upgrade system
RUN apt-get update && apt-get upgrade -y

# Install PHP, MariaDB client and utilities
RUN apt-get install -y \
    apt-utils \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget

# Configure PHP to listen to port 9000 so it can communicate with NGINX
RUN sed -i.default "/^listen\s=.*/c\listen = 0.0.0.0:9000" \
    /etc/php/[0-9]*.[0-9]*/fpm/pool.d/www.conf

# Download and install WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvzf latest.tar.gz \
    && rm latest.tar.gz \
    && mv wordpress /var/www/html/wordpress

# Configure WordPress config with database information
RUN cp /var/www/html/wordpress/wp-config-sample.php wp-config.php \
    && sed -i "s/database_name_here/$WP_DATABASE/g" wp-config.php \
    && sed -i "s/username_here/$WP_USER/g" wp-config.php \
    && sed -i "s/password_here/$WP_PASSWORD/g" wp-config.php \
    && mv wp-config.php /var/www/html/wordpress

# Create the directory where php-fpm will store the pid file
RUN mkdir -p /run/php

# Alias to php-fpm
RUN ln -s $(find /usr/sbin/ -name 'php-fpm*') /usr/sbin/php-fpm

# Expose port
EXPOSE 9000

# Run php-fpm
CMD ["php-fpm", "-F"]