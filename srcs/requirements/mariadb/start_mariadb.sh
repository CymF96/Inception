#!/bin/bash

if [ -f "/run/secrets/db_admin_pwd" ]; then
	DB_ADMIN_PWD=$(cat /run/secrets/db_admin_pwd)
fi
if [ -f "/run/secrets/db_pwd" ]; then
	DB_PWD=$(cat /run/secrets/db_pwd)
fi

echo "DB_ADMIN_ID"$DB_ADMIN_ID
echo "DATABASE"$DATABASE
echo "DB_ADMIN_PWD"$DB_ADMIN_PWD
echo "DB_PWD"$DB_PWD

service mariadb start

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then 
	echo "Database already exists"
else

#delete test user and database
echo "DELETE FROM mysql.user WHERE User='';"
echo "DROP DATABASE IF EXISTS test;"

#create db root and normal
echo "GRANT ALL ON *.* TO '$DB_ADMIN_ID'@'localhost' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;"
#UPDATE mysql.user SET Host='localhost' WHERE User='$DB_ADMIN_ID';
echo "GRANT SELECT, INSERT, UPDATE ON *.* TO '$DB_ID'@'localhost' IDENTIFIED BY '$DB_PWD';"

mariadb < /usr/bin/init.sql

fi 
