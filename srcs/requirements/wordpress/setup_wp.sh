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

	# Generate auth keys
	echo "Generating security keys..."
	curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-keys.txt
	line1=$(head -n 1 /tmp/wp-keys.txt)
	line2=$(head -n 2 /tmp/wp-keys.txt)
	line3=$(head -n 3 /tmp/wp-keys.txt)
	line4=$(head -n 4 /tmp/wp-keys.txt)
	line5=$(head -n 5 /tmp/wp-keys.txt)
	line6=$(head -n 6 /tmp/wp-keys.txt)
	line7=$(head -n 7 /tmp/wp-keys.txt)
	line8=$(head -n 8 /tmp/wp-keys.txt)
	sed -i "/'AUTH_KEY'/c\\$line1" $WP_PATH/wp-config.php
	sed -i "/'SECURE_AUTH_KEY'/c\\$line2" $WP_PATH/wp-config.php
	sed -i "/'LOGGED_IN_KEY'/c\\$line3" $WP_PATH/wp-config.php
	sed -i "/'NONCE_KEY'/c\\$line4" $WP_PATH/wp-config.php
	sed -i "/'AUTH_SALT'/c\\$line5" $WP_PATH/wp-config.php
	sed -i "/'SECURE_AUTH_SALT'/c\\$line6" $WP_PATH/wp-config.php
	sed -i "/'LOGGED_IN_SALT'/c\\$line7" $WP_PATH/wp-config.php
	sed -i "/'NONCE_SALT'/c\\$line8" $WP_PATH/wp-config.php
	rm /tmp/wp-keys.tx

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
