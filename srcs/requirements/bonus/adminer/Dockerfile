# Base image
FROM        debian:bullseye

# Update and upgrade system & install wget and php
RUN         apt -y update && apt -y upgrade
RUN         apt -y install wget php7.4 php7.4-fpm

# Expose port 9000
EXPOSE      9000

# Copy Entrypoint script
COPY        ./tools/entrypoint.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/entrypoint.sh

# Run php-fpm
ENTRYPOINT  [ "bash", "/usr/local/bin/entrypoint.sh" ]