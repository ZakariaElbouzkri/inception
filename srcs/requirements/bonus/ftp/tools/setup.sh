#!/bin/bash

set -e

if ! id $FTP_USER &>/dev/null; then
    useradd -m -u 1001 $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/run/vsftpd/empty/ /home/$FTP_USER/ && \
    chown -R "$FTP_USER:$FTP_USER" /home/$FTP_USER /var/run/vsftpd/
    chmod 775 /home/$FTP_USER /var/run/vsftpd

echo "local_root=/home/$FTP_USER" >> /etc/vsftpd/vsftpd.conf

exec "$@"
