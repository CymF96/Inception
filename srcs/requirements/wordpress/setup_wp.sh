#!/bin/bash

#checking if wp-config exist (meaning wordpress is already installed)
if [ -f /var/www/wordpress/wp-config.php ]
then
	echo "wordpress already downloaded"
else

	# Downloading wordpress package
	mkdir -p $WP_PATH
	echo "creating directory for wordpress at $WP_PATH"
	curl -L https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
	tar -xzf /tmp/wordpress.tar.gz -C /tmp
	cp -r /tmp/wordpress/* $WP_PATH && rm -rf /tmp/wordpress

	#setting permission to www-data for nginx and wordpress share volume
	echo "Setting permissions..."
	chown -R www-data:www-data $WP_PATH
	chmod -R 755 $WP_PATH

	echo "Configuring WordPress..."
	cp $WP_PATH/wp-config-sample.php $WP_PATH/wp-config.php

	# Replace database configuration in wp-config.php
	sed -i "s/database_name_here/$DATABASE/" $WP_PATH/wp-config.php
	sed -i "s/username_here/$DB_ID/" $WP_PATH/wp-config.php
	sed -i "s/password_here/$DB_PWD/" $WP_PATH/wp-config.php
	sed -i "s/localhost/$DB_HOST/" $WP_PATH/wp-config.php

	# Installing CLI for Wordpress admin installation
	echo "Installing WordPress CLI..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	#checking mariadb has finished setup and listening on expose port 3306
	until nc -z "$DB_HOST" 3306; do
		sleep 5
	done

	# setting wordpress admin page
	echo "Setting up WordPress..."
	su -s /bin/bash www-data -c "wp core install --path=$WP_PATH \
    --url='$SITE_URL' \
    --title='$SITE_TITLE' \
    --admin_user='$DB_ADMIN_ID' \
    --admin_password='$DB_ADMIN_PWD' \
    --admin_email='admin@example.com'"

	echo "WordPress installation completed!"

fi

#executing CMD from Dockerfile after script closure
exec "$@"
