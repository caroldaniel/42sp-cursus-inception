# Base image
FROM debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG WP_DATABASE
ARG WP_USER
ARG WP_PASSWORD

# Update and upgrade system & install MariaDB
RUN apt -y update && apt -y upgrade
RUN apt -y install mariadb-server

# Copy the MariaDB configuration file and dump.sql file
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/mariadb.cnf
# COPY ./conf/dump.sql /tmp/dump.sql

# Expose port to the host
EXPOSE 3306

# Copy the initialization script to the container
COPY ./conf/init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod 755 /docker-entrypoint-initdb.d/init.sh

# Run MariaDB
CMD ["mysqld_safe"]