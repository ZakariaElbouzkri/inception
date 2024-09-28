FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;" ]
