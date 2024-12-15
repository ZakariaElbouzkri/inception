FROM debian:buster

RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY conf/certs/ /etc/nginx/certs/

CMD ["nginx", "-g", "daemon off;"]
