# Base image
FROM debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG WP_DATABASE
ARG WP_USER
ARG WP_PASSWORD

# Update and upgrade system
RUN apt -y update && apt -y upgrade

# Install MariaDB
RUN apt -y install mariadb-server

# Modify server configuration file so that:
# - MariaDB can connect to the Docker network
# - MariaDB can listen to all IP addresses from that network
RUN echo "[mysqld]" >> /etc/mysql/mariadb.conf.d/42-server.cnf
RUN echo "skip-networking=0" >> /etc/mysql/mariadb.conf.d/42-server.cnf
RUN echo "skip-bind-address" >> /etc/mysql/mariadb.conf.d/42-server.cnf

# Copy the dump.sql file that will be used to initialize the database
COPY ./conf/dump.sql /tmp/dump.sql

# Start MariaDB service and initialize database
RUN service mariadb start

# Create database, user and grant privileges
RUN mariadb -u root -e "CREATE DATABASE IF NOT EXISTS $WP_DATABASE; \
    CREATE USER $WP_USER'@'%' identified  by '$WP_PASSWORD'; \
    GRANT ALL PRIVILEGES ON $WP_DATABASE.* TO '$WP_USER'@'%' \
    IDENTIFIED BY '$WP_PASSWORD'; \
    FLUSH PRIVILEGES;"

# Import dump.sql file to database
RUN mariadb -u root $WP_DATABASE < /tmp/dump.sql

# stop mariadb service
RUN service mariadb stop

# Expose port
EXPOSE 3306

# Run MariaDB
CMD ["mysqld_safe"]
