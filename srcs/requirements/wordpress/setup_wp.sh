#!/bin/bash

sleep 5
if [ ! -f /var/www/cofische/wp-config.php ]; then
	wp config create --allow-root  --skip-check\
	--dbname=$DATABASE \
	--dbuser=$DB_ADMIN_IDR \
	--dbpass=$BD_ADMIN_PWD \
	--dbhost=$DB_HOST 

	echo "WordPress installation completed"
	sleep 5
	cd /var/www/cofische
	
	wp core install --allow-root --path=/var/www/cofische \
		--url="$SITE_URL" \
		--title="$SITE_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL"
	
	echo "WordPress configuration completed"

fi

exec "$@"
