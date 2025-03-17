#!/bin/bash

if [ -f "/run/secrets/db_admin_pwd" ]; then
	DB_ADMIN_PWD=$(cat /run/secrets/db_admin_pwd)
fi

if [ -f "/run/secrets/db_pwd" ]; then
	DB_PWD=$(cat /run/secrets/db_pwd)
fi

service mariadb start
sleep 20
export $(printenv | cut -d= -f1)
echo "DB_ADMIN_ID"$DB_ADMIN_ID
echo "DATABASE"$DATABASE
echo "DB_ADMIN_PWD"$DB_ADMIN_PWD
echo "DB_PWD"$DB_PWD
envsubst < init.sql | mariadb
