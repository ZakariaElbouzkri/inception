#!/bin/bash

set -e

# Check if WordPress is already downloaded
if [ ! -f wp-load.php ]; then
    echo "WordPress not found, starting download..."
    wp core download --allow-root
    echo "WordPress successfully downloaded."
else
    echo "WordPress is already downloaded."
fi

# Indicate that a connection to MariaDB has been successfully established
echo "Successfully connected to MariaDB."

# Check if wp-config.php exists, and create it if not
if [ ! -f wp-config.php ]; then
    echo "wp-config.php not found, creating configuration file..."
    wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=${MYSQL_HOST} --allow-root
    echo "wp-config.php successfully created."
else
    echo "wp-config.php already exists."
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "WordPress not installed, proceeding with installation..."
    wp core install \
    --url=${WORDPRESS_URL} \
    --title=${WP_SITE_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASS} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --skip-email --allow-root
    echo "WordPress successfully installed."

    # Install and activate Redis Cache plugin
    echo "Installing and activating Redis Cache plugin..."
    wp plugin install redis-cache --activate --allow-root
    echo "Redis Cache plugin activated."

    # Set Redis connection parameters in wp-config.php
    echo "Configuring Redis settings..."
    wp config set WP_REDIS_HOST "${WP_REDIS_HOST}" --allow-root
    wp config set WP_REDIS_PORT ${WP_REDIS_PORT} --raw --allow-root
    echo "Redis settings configured."

    # Enable Redis object caching
    wp redis enable --allow-root
    echo "Redis object caching enabled."
else
    echo "WordPress is already installed."
fi

# Wait for a successful connection to the MariaDB database
echo "Checking connection to the database..."
until mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES;" > /dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 5
done
echo "Successfully connected to the database."

# Start the PHP-FPM process
echo "Starting PHP-FPM..."
exec "$@"
