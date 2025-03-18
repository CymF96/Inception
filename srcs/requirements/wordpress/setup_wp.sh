#!/bin/bash

cd /var/www/cofische

if [ ! -f /var/www/cofische/wp-config.php ]; then
	echo "wp-config.php not found"

else

	if ! wp core is-installed; then
		wp core install --allow-root \
			--url="$SITE_URL" \
			--title="$SITE_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PASSWORD" \
			--admin_email="$WP_ADMIN_EMAIL" \
			
	fi

	echo "wordpress installation completed"

fi

exec "$@"
