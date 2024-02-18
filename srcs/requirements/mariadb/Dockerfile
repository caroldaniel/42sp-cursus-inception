# Base image
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         MYSQL_DATABASE
ARG         MYSQL_USER
ARG         MYSQL_PASSWORD
ARG         MYSQL_ROOT_PASSWORD

# Update and upgrade system & install MariaDB
RUN         apt -y update && apt -y upgrade
RUN         apt -y install mariadb-server mariadb-client

#allow mysqld daemon to run, purge and recreate /var/lib/mysql with appropriate ownership
RUN			mkdir -p /var/lib/mysql /var/run/mysqld
RUN			chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN			chmod 777 /var/run/mysqld

# Copy the MariaDB configuration file and dump.sql file
COPY        ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/
RUN         chmod 644 /etc/mysql/mariadb.conf.d/mariadb.cnf
COPY        ./conf/dump.sql /usr/local/bin/

# Execute MariaDB Initialization script
COPY        ./tools/init.sh /usr/local/bin/
RUN         bash /usr/local/bin/init.sh

# Expose port to the host
EXPOSE      3306

# Run MariaDB
ENTRYPOINT  [ "mysqld_safe" ]