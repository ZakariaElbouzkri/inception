#!/bin/bash

set -e

MARKER_FILE='/var/www/html/.wp_installed'

# Wait for MariaDB to be ready
until mysql -h "${MYSQL_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 3
done

# Wait for Redis to be ready
until redis-cli -h "${WP_REDIS_HOST}" -p "${WP_REDIS_PORT}" ping | grep -q "PONG"; do
    echo "Waiting for Redis connection..."
    sleep 3
done


if [ -f "$MARKER_FILE" ]; then
    echo "wordpress already installed, Starting PHP-FPM..."
    exec "$@"
fi

wp core download --allow-root

wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${MYSQL_HOST}" \
    --allow-root

wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WP_SITE_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

wp user create "${WP_USER_USERNAME}" "${WP_USER_EMAIL}" \
    --role="${WP_USER_ROLE}" \
    --user_pass="${WP_USER_PASS}" \
    --allow-root

wp plugin install redis-cache --activate --allow-root
wp config set WP_REDIS_HOST "${WP_REDIS_HOST}" --allow-root
wp config set WP_REDIS_PORT "${WP_REDIS_PORT}" --raw --allow-root
wp redis enable --allow-root

touch "$MARKER_FILE"

echo "Starting PHP-FPM..."
exec "$@"
