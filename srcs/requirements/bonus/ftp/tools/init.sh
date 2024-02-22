#!/bin/bash

if [ -z "$FTP_USER" ] || [ -z "$FTP_PASSWORD" ]; then
    echo "FTP_USER and FTP_PASSWORD must be set"
    exit 1
fi

if [ ! -f /usr/local/bin/vsftpd.conf.bak ]; then

    # Create empty directory for the FTP server
    mkdir -p /var/run/vsftpd/empty

    # Create a user and a home directory for it
    adduser --disabled-password $FTP_USER --gecos ""
    mkdir -p /home/$FTP_USER/ftp

    # Set the user's password
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

    # Set the user's home directory
    chown -R $FTP_USER:$FTP_USER /home/$FTP_USER

    # Set permissions for the user's home directory
    chmod 755 /home/$FTP_USER/ftp

    # Add the user to the FTP server

    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist

    # Copy the configuration file to the FTP server
    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
    mv /usr/local/bin/vsftpd.conf /etc/vsftpd.conf
    sed -i "s/^local_root=.*/local_root=\/home\/$FTP_USER\/ftp/" /etc/vsftpd.conf
    chmod 644 /etc/vsftpd.conf

    # Unset variables
    unset FTP_USER
    unset FTP_PASSWORD

fi

# Start the FTP server
vsftpd /etc/vsftpd.conf