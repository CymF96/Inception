#!/bin/bash
set -e

# Ensure the data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    echo "Starting MariaDB for initial setup..."
    mysqld_safe --bind-address=0.0.0.0 &

    # Wait for MariaDB to be ready
    sleep 5
    until mariadb -u root -e "SELECT 1" &>/dev/null; do
        echo "Waiting for MariaDB to start..."
        sleep 2
    done

    echo "Initializing database tables..."
    mariadb -u root <<EOF
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE IF NOT EXISTS $DATABASE;
    GRANT ALL ON $DATABASE.* TO '$DB_ADMIN_ID'@'localhost' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;
    GRANT SELECT, INSERT, UPDATE ON $DATABASE.* TO '$DB_ID'@'localhost' IDENTIFIED BY '$DB_PWD';
    USE $DATABASE;
    
    CREATE TABLE IF NOT EXISTS Visited_countries (
        country VARCHAR(50),
        nb_visits INT,
        last_visited DATE
    );

    INSERT INTO Visited_countries (country, nb_visits, last_visited) 
    VALUES ('France', 5, '2024-12-25'), ('Japan', 1, '2019-09-15'), ('USA', 3, '2016-07-01');

    FLUSH PRIVILEGES;
EOF

    echo "Database setup completed."
fi

# Start MariaDB in the foreground
exec mysqld_safe --bind-address=0.0.0.0

