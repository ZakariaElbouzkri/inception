FROM debian:buster

# Install vsftpd and create necessary directories
RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN useradd -u 1001 -m -d /home/ftp $FTP_USER && \
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

EXPOSE 21 30000-30010

ENTRYPOINT ['/setup.sh']

CMD ["vsftpd"]
