FROM debian:bullseye

# Set environment variables for the database connection
# ENV MYSQL_DATABASE=mysql_database \
#     MYSQL_USER=mysql_user \
#     MYSQL_PASSWORD=mysql_password \
#     MYSQL_HOST=127.0.0.1 \
#     WORDPRESS_URL=http://localhost \
#     WP_ADMIN_USER=admin \
#     WP_ADMIN_PASS=admin_password \
#     WP_ADMIN_EMAIL=admin_email    

# Install necessary packages
RUN apt-get update \
    && apt-get install -y php7.4 php7.4-fpm php7.4-mysql mariadb-client curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set the working directory
WORKDIR /var/www/html

# Download WordPress
RUN wp core download --allow-root

# Set file ownership for PHP-FPM
RUN chown -R www-data:www-data /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

COPY conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy the entrypoint script
COPY tools/script.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh


EXPOSE 9000
# Entry point
ENTRYPOINT [ "/entrypoint.sh" ]

# Run PHP-FPM in the foreground
CMD ["php-fpm7.4", "-F"]
