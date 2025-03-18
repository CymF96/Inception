#!/bin/bash

if [ ! -f /var/www/cofische/wp-config.php ]; then

	#move custom wp-config.php to /var/www/cofische + give permission and ownership to wd-php
	mv /tmp/wp-config.php /var/www/cofische/wp-config.php
	chown -R www-data:www-data /var/www/cofische/wp-config.php && chmod +x /var/www/cofische/wp-config.php
	cd /var/www/cofische || { echo "Failed to change directory!"; exit 1; }

	#wait for correct move and setup wordpress
	#sleep 2
	#if ! wp core is-installed; then
	#	wp core install --allow-root \
	#		--url="$SITE_URL" \
	#		--title="$SITE_TITLE" \
	#		--admin_user="$WP_ADMIN_USER" \
	#		--admin_password="$WP_ADMIN_PASSWORD" \
	#		--admin_email="$WP_ADMIN_EMAIL" \
		
	#fi


	echo "wordpress installation completed"

else

	echo "wordpress already installed"
	service php8.2-fpm start

fi

exec "$@"
