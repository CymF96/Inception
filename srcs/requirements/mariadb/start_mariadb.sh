#!/bin/bash
set -e  # Exit on error

mysqld --user=mysql --bind-address=0.0.0.0

# Start MariaDB service
#service mariadb start

# Check if database exists
if [ -d "/var/lib/mysql/$DATABASE" ]; then 
	echo "Database already exists, starting service only"
else
	echo "Initializing database..."

	# Execute SQL commands
	mariadb -u root <<EOF
	DELETE FROM mysql.user WHERE User='';
	DROP DATABASE IF EXISTS test;
	GRANT ALL ON *.* TO '$DB_ADMIN_ID'@'localhost' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;
	GRANT SELECT, INSERT, UPDATE ON *.* TO '$DB_ID'@'localhost' IDENTIFIED BY '$DB_PWD';
	FLUSH PRIVILEGES;
EOF

	#Execute additional initialization SQL file
	mariadb -u $DB_ADMIN_ID -p $DB_ADMIN_PWD < /usr/local/bin/init.sql

	echo "Database setup completed."
fi
