FROM debian:bullseye

# Install necessary packages
RUN apt-get update \
    && apt-get install -y php7.4 php7.4-fpm php7.4-mysql mariadb-client curl redis-tools php-redis\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/wordpress && \
    chown -R www-data:www-data /var/www /run/php

RUN sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/wordpress

COPY tools/script.sh /setup.sh

ENTRYPOINT [ "bash", "/setup.sh" ]

# Run PHP-FPM in the foreground
CMD ["php-fpm7.4", "-F"]
