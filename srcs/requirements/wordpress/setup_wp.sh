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

	# Adding test-db.php to the correct folder
	mv /tmp/test-db.php /var/www/wordpress/test-db.php
	mv /tmp/tanzania /var/www/wordpress/

	#setting permission to www-data for nginx and wordpress share volume
	echo "Setting permissions..."
	chown -R www-data:www-data $WP_PATH
	chmod -R 755 $WP_PATH

	# Replace database configuration in test-db.php
	sed -i "s/database_name_here/$DATABASE/" $WP_PATH/test-db.php
	sed -i "s/username_here/$DB_ADMIN_ID/" $WP_PATH/test-db.php
	sed -i "s/password_here/$DB_ADMIN_PWD/" $WP_PATH/test-db.php
	sed -i "s/localhost/$DB_HOST/" $WP_PATH/test-db.php

	echo "Configuring WordPress..."
	cp $WP_PATH/wp-config-sample.php $WP_PATH/wp-config.php

	# Replace database configuration in wp-config.php
	sed -i "s/database_name_here/$DATABASE/" $WP_PATH/wp-config.php
	sed -i "s/username_here/$DB_ADMIN_ID/" $WP_PATH/wp-config.php
	sed -i "s/password_here/$DB_ADMIN_PWD/" $WP_PATH/wp-config.php
	sed -i "s/localhost/$DB_HOST/" $WP_PATH/wp-config.php

	# Generate auth keys
	echo "Generating security keys..."
	curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-keys.txt
	line1=$(sed -n '1p' /tmp/wp-keys.txt)
	line2=$(sed -n '2p' /tmp/wp-keys.txt)
	line3=$(sed -n '3p' /tmp/wp-keys.txt)
	line4=$(sed -n '4p' /tmp/wp-keys.txt)
	line5=$(sed -n '5p' /tmp/wp-keys.txt)
	line6=$(sed -n '6p' /tmp/wp-keys.txt)
	line7=$(sed -n '7p' /tmp/wp-keys.txt)
	line8=$(sed -n '8p' /tmp/wp-keys.txt)
	sed -i "51c\\$line1" $WP_PATH/wp-config.php
	sed -i "52c\\$line2" $WP_PATH/wp-config.php
	sed -i "53c\\$line3" $WP_PATH/wp-config.php
	sed -i "54c\\$line4" $WP_PATH/wp-config.php
	sed -i "55c\\$line5" $WP_PATH/wp-config.php
	sed -i "56c\\$line6" $WP_PATH/wp-config.php
	sed -i "57c\\$line7" $WP_PATH/wp-config.php
	sed -i "58c\\$line8" $WP_PATH/wp-config.php
	rm /tmp/wp-keys.txt

	# Installing CLI for Wordpress admin installation
	echo "Installing WordPress CLI..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	#checking mariadb has finished setup and listening on expose port 3306
	echo "Waiting for database..."
	until nc -z "$DB_HOST" 3306; do
		echo "Database not ready yet... waiting"
		sleep 2
	done
	echo "Database is ready!"
	
	# setting wordpress admin page
	echo "Setting up WordPress..."
	su -s /bin/bash www-data -c "wp core install --path=$WP_PATH \
	--url='$SITE_URL' \
	--title='$SITE_TITLE' \
	--admin_user='$WP_ADMIN_ID' \
	--admin_password='$WP_ADMIN_PWD' \
	--admin_email='$ADMIN_EMAIL'"

	echo "WordPress installation completed!"

fi

#executing CMD from Dockerfile after script closure
exec "$@"
