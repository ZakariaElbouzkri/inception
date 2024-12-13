# Use the Debian base image
FROM debian:bullseye

# Install necessary packages
RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for FTP files and a dummy secure_chroot_dir
RUN mkdir -p /srv/ftp/wordpress && \
    mkdir -p /var/run/vsftpd/empty

# Configure vsftpd
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/setup.sh /setup.sh

ENTRYPOINT [ "bash", "/setup.sh" ]
# Expose FTP port

# Start the FTP server
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
