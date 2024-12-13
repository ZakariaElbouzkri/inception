FROM debian:oldoldstable

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/script.sh .

EXPOSE 3306

ENTRYPOINT [ "bash", "./script.sh" ]

CMD [ "mysqld" ]
