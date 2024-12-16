FROM debian:buster


RUN apt-get update && apt-get install -y \
    php \
    curl \
    php-mysqli \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -L -k -o adminer.php https://www.adminer.org/latest.php
RUN curl -L -k -o adminer.css https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css

CMD ["php", "-S", "0.0.0.0:8080"]
