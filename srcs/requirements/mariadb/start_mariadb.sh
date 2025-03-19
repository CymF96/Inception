#!/bin/bash
set -e  # Exit on error

# Wait for MariaDB to be ready
until mariadb -u root -e "SELECT 1" &> /dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Check if database exists
if mariadb -u root -e "SHOW DATABASES LIKE '$DATABASE';" | grep -q "$DATABASE"; then 
    echo "Database ($DATABASE) already exists, starting service only"
else
    echo "Initializing database..."
    
    mariadb -u root <<EOF
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE $DATABASE;
    GRANT ALL ON *.* TO '$DB_ADMIN_ID'@'%' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;
    GRANT SELECT, INSERT, UPDATE ON *.* TO '$DB_ID'@'%' IDENTIFIED BY '$DB_PWD';
    USE $DATABASE;
    
    CREATE TABLE Visited_countries (
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

exec "$@"
