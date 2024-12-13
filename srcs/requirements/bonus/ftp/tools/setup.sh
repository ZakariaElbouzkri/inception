if ! id $FTP_USER &>/dev/null; then
    useradd -m -u 1001 $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Always ensure correct permissions for the FTP directories
chmod 755 /srv/ftp
chown -R $FTP_USER:$FTP_USER /srv/ftp
chown -R $FTP_USER:$FTP_USER /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd

# Start the FTP service
exec $@
