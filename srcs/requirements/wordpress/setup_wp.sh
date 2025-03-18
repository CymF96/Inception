#!/bin/bash

if [ ! -f wp-config.php ]; then
	echo "wp-config.php not found"

else

	if [ ! wp core is-installed --allow-root ]; then
		wp core install \
			--url="$SITE_URL"
			--title="$SITE_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PASSWORD" \
			--admin_email="$WP_ADMIN_EMAIL" \
			--allow-root
	fi

	echo "wordpress installation completed"

fi

exec "$@"
