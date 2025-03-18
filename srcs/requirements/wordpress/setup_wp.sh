#!/bin/bash

# Wait to ensure the volume is mounted

if [ ! -f /tmp/wp-config.php ]; then
	echo "wp-config.php not found"

else

	mv /tmp/wp-config.php /var/www/cofische/wp-config.php
	chown -R www-data:www-data /var/www/cofische/wp-config.php && chmod +x /var/www/cofische/wp-config.php
	# Debugging: Check if the directory exists before proceeding
	echo "inside /var/www/cofische: " && ls -la /var/www/cofische || echo "Directory not found!"
	cat /var/www/cofische/wp-config.php
	echo "inside /etc/php/8.2/pool.d/: " && ls -la /etc/php/8.2/pool.d/|| echo "Directory not found!"
	cd /var/www/cofische || { echo "Failed to change directory!"; exit 1; }
	sleep 2
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
