#!/bin/bash
set -e  # Exit on error

# Load secrets if they exist
#if [ -f "/run/secrets/db_admin_pwd" ]; then
#	DB_ADMIN_PWD=$(cat /run/secrets/db_admin_pwd)
#fi
#if [ -f "/run/secrets/db_pwd" ]; then
#	DB_PWD=$(cat /run/secrets/db_pwd)
#fi

# Debugging output
echo "DB_ADMIN_ID: $DB_ADMIN_ID"
echo "DATABASE: $DATABASE"
echo "DB_ADMIN_PWD: [HIDDEN]"
echo "DB_PWD: [HIDDEN]"

# Start MariaDB service
service mariadb start

# Check if database exists
if [ -d "/var/lib/mysql/$DATABASE" ]; then 
	echo "Database already exists"
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

	# Execute additional initialization SQL file
	mariadb -u root < /usr/local/bin/init.sql

	echo "Database setup completed."
fi
