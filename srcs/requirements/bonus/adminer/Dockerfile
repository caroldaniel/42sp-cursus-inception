# Base image
FROM        debian:bullseye

# Update and upgrade system & install wget and php
RUN         apt -y update && apt -y upgrade
RUN         apt -y install wget php7.4 php7.4-fpm

# Set up php-fpm
RUN         mkdir -p /var/run/php
RUN         sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Set up adminer
RUN         mkdir -p /var/www/html
RUN         wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php
RUN         chown www-data:www-data /var/www/html/adminer.php
RUN         chmod 755 /var/www/html/adminer.php

# Expose port 9000
EXPOSE      9000

# Run php-fpm
ENTRYPOINT  [ "php-fpm7.4", "-F" ]