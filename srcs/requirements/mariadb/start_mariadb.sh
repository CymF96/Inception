#!/bin/bash

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
    mariadb --user=root --skip-password << EOF
    -- Set root password and create remote access
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PWD';
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    
    -- Remove anonymous users
    DELETE FROM mysql.user WHERE User='';
    
    -- Remove test database
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    
    -- Create database
    CREATE DATABASE IF NOT EXISTS $DATABASE;
    
    -- Create table
    USE $DATABASE;
    CREATE TABLE IF NOT EXISTS Visited_countries (
        country VARCHAR(50),
        nb_visits INT,
        last_visited DATE
    );
    
    -- Insert initial data
    INSERT INTO Visited_countries (country, nb_visits, last_visited) 
    VALUES 
        ('France', 5, '2024-12-25'),
        ('Japan', 1, '2019-09-15'),
        ('USA', 3, '2016-07-01');
    
    -- Create admin users
    CREATE USER IF NOT EXISTS '${DB_ADMIN_ID}'@'%' IDENTIFIED BY '${DB_ADMIN_PWD}';
    GRANT ALL PRIVILEGES ON *.* TO '${DB_ADMIN_ID}'@'%' WITH GRANT OPTION;
    CREATE USER IF NOT EXISTS '${DB_ID}'@'%' IDENTIFIED BY '${DB_PWD}';
    GRANT ALL PRIVILEGES ON *.* TO '${DB_ID}'@'%' WITH GRANT OPTION;
    
    -- Reload privileges
    FLUSH PRIVILEGES;
EOF
	echo "Users created successfully and mariadb service restart"
	
	# Shutdown the temporary instance
	mysqladmin -u root -p"$DB_ROOT_PWD" shutdown
fi

# Executing CMD from Dockerfile after ending the script
exec "$@"