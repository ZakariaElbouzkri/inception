FROM debian:bullseye

# Install necessary packages
RUN apt-get update \
    && apt-get install -y php7.4 php7.4-fpm php7.4-mysql mariadb-client curl redis-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /run/php /var/www/wordpress && \
    chown -R www-data:www-data /var/www /run/php

# Copy the PHP-FPM configuration
COPY conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set the working directory
WORKDIR /var/www/wordpress

# Set file ownership for PHP-FPM
# RUN chown -R www-data:www-data /var/www/wordpress

# Download WordPress
# RUN wp core download --allow-root

# Expose PHP-FPM port
EXPOSE 9000


# Copy the entrypoint script
COPY tools/script.sh /setup.sh

RUN chmod +x /setup.sh

# Entry point
ENTRYPOINT [ "bash", "/setup.sh" ]

# Run PHP-FPM in the foreground
CMD ["php-fpm7.4", "-F"]
