#!/bin/bash

set -e

MARKER_FILE='/home/ftp/.ftp_installed'

if [ -f "$MARKER_FILE" ]; then
    exec "$@"
if

useradd -u 1001 -m -d /home/ftp $FTP_USER && \
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "pasv_min_port=30000" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=30010" >> /etc/vsftpd/vsftpd.conf
echo "local_root=${FTP_HOMEDIR}" >> /etc/vsftpd/vsftpd.conf


# Always ensure correct permissions for the FTP directories
chmod 755 /srv/ftp
chown -R $FTP_USER:$FTP_USER /srv/ftp
chown -R $FTP_USER:$FTP_USER /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd

# Start the FTP service
exec $@
