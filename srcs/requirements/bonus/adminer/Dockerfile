FROM debian:buster


RUN apt-get update && apt-get install -y \
    php php-mysql \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -L -k -o adminer.php https://www.adminer.org/latest.php

RUN chown -R www-data:www-data /var/www/html/ && \
    chmod 755 /var/www/html/adminer.php

CMD ["php", "-S", "0.0.0.0:8080", "adminer.php"]
