FROM debian:oldoldstable

RUN apt-get update && apt-get install -y \
    nginx openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY conf/ssl/ /etc/nginx/

COPY tools/script.sh .

CMD [ "bash", "./script.sh" ]
