FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php-mysqli \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set permissions
RUN mkdir -p /run/php /var/www/adminer && \
    chown -R www-data:www-data /var/www /run/php

# Update php-fpm to listen on TCP port 9000
RUN sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/adminer/

# Download Adminer
RUN curl -L -k -o adminer.php https://www.adminer.org/latest.php

# Expose port for Nginx to link
EXPOSE 8080

# Start PHP-FPM and Nginx
CMD [ "php-fpm7.4", "-F" ]
