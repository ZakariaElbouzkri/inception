if ! id $FTP_USER &>/dev/null; then
    useradd -m $FTP_USER

    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    chmod 755 /srv/ftp

    chown -R $FTP_USER:$FTP_USER /srv/ftp
    chown -R $FTP_USER:$FTP_USER /var/run/vsftpd/empty

    chmod 755 /var/run/vsftpd
fi

exec $@
