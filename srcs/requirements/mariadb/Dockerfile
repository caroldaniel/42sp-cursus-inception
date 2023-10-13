# Base image
FROM debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG WP_DATABASE
ARG WP_USER
ARG WP_PASSWORD

# Update and upgrade system
RUN apt-get update && apt-get upgrade -y

# Install MariaDB
RUN apt-get install mariadb-server -y

# Modify server configuration file so that:
# - MariaDB connects to the Docker network
# - MariaDB listens to all IP addresses from that network
RUN echo "[mysqld]" >> /etc/mysql/mariadb.conf.d/42-server.cnf
RUN echo "skip-networking=0" >> /etc/mysql/mariadb.conf.d/42-server.cnf
RUN echo "skip-bind-address" >> /etc/mysql/mariadb.conf.d/42-server.cnf

