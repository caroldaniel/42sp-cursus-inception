#!/bin/bash

# Start the FTP server
service vsftpd start

# Add the FTP user, change the password and declare him the owner of the FTP directory
adduser $FTP_USER --disabled-password
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
echo "$FTP_USER" | tee -a /etc/vsftpd/vsftpd.userlist

# Create the repository for the FTP server
mkdir -p /home/ftp
chown -R nobody:nogroup /home/ftp
chmod a-w /home/ftp

# Create the repository for the FTP files
mkdir -p /home/ftp/wordpress
chown -R $FTP_USER:$FTP_USER /home/ftp/wordpress

# Configure the FTP server via vsftpd.conf file
sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd/vsftpd.conf
sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/' /etc/vsftpd/vsftpd.conf

echo -e "\n\
local_enable=YES\n\
allow_writeable_chroot=YES\n\
local_root=/home/ftp/\n\
pasv_enable=YES\n\
pasv_min_port=21000\n\
pasv_max_port=21010\n\
userlist_file=/etc/vsftpd/vsftpd.userlist\
" | tee -a /etc/vsftpd/vsftpd.conf

service vsftpd stop