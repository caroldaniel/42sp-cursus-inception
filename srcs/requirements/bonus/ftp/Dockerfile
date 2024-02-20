FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         FTP_USER
ARG         FTP_PASSWORD

# Update and upgrade system & install FTP
RUN         apt -y update && apt -y upgrade
RUN         apt -y install vsftpd

# Set up FTP
COPY        ./tools/init.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/init.sh
RUN         bash /usr/local/bin/init.sh

# Expose port
EXPOSE      21

# Run FTP
ENTRYPOINT  [ "vsftpd" ]