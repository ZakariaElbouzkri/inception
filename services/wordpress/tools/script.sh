#!/bin/bash

# Ensure PHP-FPM socket directory exists
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Wait for the database to be ready
until mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES;" > /dev/null 2>&1; do
  echo "Waiting for database connection..."
  sleep 5
done

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
  wp config create \
  --dbname=${MYSQL_DATABASE} \
  --dbuser=${MYSQL_USER} \
  --dbpass=${MYSQL_PASSWORD} \
  --dbhost=${MYSQL_HOST} --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root; then
  wp core install \
  --url=${WORDPRESS_URL} \
  --title=${WP_SITE_TITLE} \
  --admin_user=${WP_ADMIN_USER} \
  --admin_password=${WP_ADMIN_PASS} \
  --admin_email=${WP_ADMIN_EMAIL} \
  --skip-email --allow-root
  
  wp plugin install redis-cache --activate --allow-root
  wp config set WP_REDIS_HOST ${WP_REDIS_HOST} --raw --allow-root
  wp config set WP_REDIS_PORT ${WP_REDIS_PORT} --raw --allow-root
  wp redis enable --allow-root
fi

# Start PHP-FPM
exec "$@"
