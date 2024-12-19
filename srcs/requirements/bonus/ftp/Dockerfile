FROM debian:buster

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup.sh /setup.sh

EXPOSE 21 30000-30010

ENTRYPOINT [ "/setup.sh" ]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
