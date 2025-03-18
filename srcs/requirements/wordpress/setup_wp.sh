#!/bin/bash

#if pgrep -x "php-fpm8.2" > /dev/null; then
#    echo "Stopping existing PHP-FPM service..."
#    service php8.2-fpm stop
#    rm -rf /run/php/php8.2-fpm.sock  # Remove the stale socket file
#fi

#service php8.2-fpm start

if [ ! -f /var/www/cofische/wp-config.php ]; then

	#move custom wp-config.php to /var/www/cofische + give permission and ownership to wd-php
	#mv /tmp/www.conf /etc/php/8.2/fpm/pool.d/www.conf
	cat /etc/php/8.2/fpm/pool.d/www.conf
	mv /tmp/wp-config.php /var/www/cofische/wp-config.php
	chown -R www-data:www-data /var/www/cofische/wp-config.php && chmod +x /var/www/cofische/wp-config.php
	cd /var/www/cofische || { echo "Failed to change directory!"; exit 1; }

	#wait for correct move and setup wordpress
	#sleep 2
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
