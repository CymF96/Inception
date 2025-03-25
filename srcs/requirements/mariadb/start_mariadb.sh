#!/bin/bash
set -e  # Exit on error

# Start MariaDB service
if [ -d /var/lib/mysql/$DATABASE ]; then
	
	echo "mariadb already installed"

else
	# Start MariaDB for initialization
	mysqld_safe --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock --pid-file=/var/run/mysqld/mysqld.pid &
	
	# Wait for MariaDB to become available
	until mysqladmin ping -s; do
		echo "Waiting for MariaDB to be ready..."
		sleep 2
	done

	# Setting up mariadb
	echo "setting up mariadb..."
	mariadb -e "
		-- Set root password
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PWD';
		
		-- Remove anonymous users
		DELETE FROM mysql.user WHERE User='';
		
		-- Disallow remote root login
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		
		-- Remove test database
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		
		-- Reload privileges
		FLUSH PRIVILEGES;
	"
	
	# Restart MariaDB for changes to take effect
	echo "restarting mariadb..."
	mysqladmin shutdown
	mysqld_safe --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock --pid-file=/var/run/mysqld/mysqld.pid &
	
	# Wait for MariaDB to become available again
	until mysqladmin ping -s; do
		echo "Waiting for MariaDB to restart..."
		sleep 2
	done

	# Create database if not exists
	echo "Creating new database $DATABASE"
	mariadb -e "CREATE DATABASE IF NOT EXISTS $DATABASE;"

	# Create the table Visited_countries
	echo "Creating elements inside $DATABASE"
	mariadb -e "USE $DATABASE; CREATE TABLE IF NOT EXISTS Visited_countries (
		country VARCHAR(50),
		nb_visits INT,
		last_visited DATE
	);"

	# Insert initial data into Visited_countries table
	mariadb -e "USE $DATABASE; INSERT INTO Visited_countries (country, nb_visits, last_visited) 
	VALUES 
		('France', 5, '2024-12-25'),
		('Japan', 1, '2019-09-15'),
		('USA', 3, '2016-07-01');"

	# Create admin user with root privileges
	echo "Creating new users $DB_ADMIN_ID && $DB_ID"
	mariadb -e "CREATE USER IF NOT EXISTS '${DB_ADMIN_ID}'@'%' IDENTIFIED BY '${DB_ADMIN_PWD}';"
	mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_ADMIN_ID}'@'%' WITH GRANT OPTION;"
	mariadb -e "CREATE USER IF NOT EXISTS '${DB_ID}'@'%' IDENTIFIED BY '${DB_PWD}';"
	mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_ID}'@'%' WITH GRANT OPTION;"
	mariadb -e "FLUSH PRIVILEGES;"

	echo "Users created successfully and mariadb service restart"
	
	# Shutdown the temporary instance
	mysqladmin shutdown
fi

# Executing CMD from Dockerfile after ending the script
exec "$@"