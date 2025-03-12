#!/bin/bash

export $(grep -v '^#' /var/www/.env | xargs)

if [ -f "/run/secrets/wp_admin_pwd" ]; then
	WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_pwd)
fi

if [ ! -f wp-config.php ]; then
	echo "wp-config.php not found"
fi

if [ ! wp core is-installed --allow-root ]; then
	wp core install \
		--url="$SITE_URL"
		--title="$SITE_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root
fi

rm -f /var/www/.env
rm -f /usr/local/bin/setup_wordpress.sh

