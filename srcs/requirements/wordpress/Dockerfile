FROM debian:buster

# Install PHP 7.3 and necessary dependencies
RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    mariadb-client \
    curl \
    redis-tools \
    php-redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html/ && \
    chown -R www-data:www-data /var/www/html

RUN mkdir -p /run/php/ && chown -R www-data:www-data /run/php/

WORKDIR /var/www/html

RUN sed -i "s|^listen = .*|listen = 0.0.0.0:9000|" /etc/php/7.3/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY tools/script.sh /setup.sh

ENTRYPOINT [ "/setup.sh" ]

CMD ["php-fpm7.3", "--nodaemonize"]
