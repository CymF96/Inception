#!/bin/bash

if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else

####### MANDATORY PART ##########

	#Download wordpress and all config file
	curl -LO http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress

	#Inport env variables in the config file
	sed -i "s/username_here/$DB_ADMIN_ID/g" wp-config-sample.php
	sed -i "s/password_here/$DB_ADMIN_PWD/g" wp-config-sample.php
	sed -i "s/localhost/$DB_HOST/g" wp-config-sample.php
	sed -i "s/database_name_here/$MDATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

	wp core install --allow-root --path=/var/www/cofische \
		--url="$SITE_URL" \
		--title="$SITE_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL"
	
	echo "WordPress configuration completed"

fi

exec "$@"
