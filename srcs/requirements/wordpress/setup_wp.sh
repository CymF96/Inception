#!/bin/bash

sleep 5
if [ ! -f /var/www/cofische/wp-config.php ]; then
	wp config create --allow-root  --skip-check\
	--dbname=$DATABASE \
	--dbuser=$DB_ADMIN_IDR \
	--dbpass=$BD_ADMIN_PWD \
	--dbhost=$DB_HOST 

	wp core install --allow-root --path=/var/www/cofische \
		--url="$SITE_URL" \
		--title="$SITE_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL"
	
	echo "WordPress installation completed"

fi

exec "$@"









#if [ -f /tmp/wp-config.php ]; then
#    # Move custom wp-config.php to the right location and set permissions
#    mv -f /tmp/wp-config.php /var/www/cofische/wp-config.php
#    chown -R www-data:www-data /var/www/cofische/wp-config.php
#    chmod 644 /var/www/cofische/wp-config.php
#
#    # Change directory safely
#    cd /var/www/cofische || { echo "Failed to change directory!"; exit 1; }
#    echo "wp-config.php copied to the correct folder"
#
#    # Check if WordPress is already installed
#    if ! wp core is-installed --allow-root --path=/var/www/cofische; then
#        wp core install --allow-root --path=/var/www/cofische \
#            --url="$SITE_URL" \
#            --title="$SITE_TITLE" \
#            --admin_user="$WP_ADMIN_USER" \
#            --admin_password="$WP_ADMIN_PASSWORD" \
#            --admin_email="$ADMIN_EMAIL"
#        echo "WordPress installation completed"
#    else
#        echo "WordPress is already installed"
#    fi
#fi
#
#exec "$@"
