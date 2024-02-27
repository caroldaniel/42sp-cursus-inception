# Base image
FROM        debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG         FTP_USER
ARG         FTP_PASSWORD

# Set environment variables
ENV         FTP_USER=${FTP_USER}
ENV         FTP_PASSWORD=${FTP_PASSWORD}

# Update and upgrade system & install FTP
RUN         apt -y update && apt -y upgrade
RUN         apt -y install vsftpd ftp

# Set up FTP
COPY        ./conf/vsftpd.conf /usr/local/bin/
COPY        ./tools/init.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/init.sh

# Expose port
EXPOSE      20 21 21100-21110

# Run FTP
ENTRYPOINT  [ "bash", "/usr/local/bin/init.sh" ]