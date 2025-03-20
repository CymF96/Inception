#!/bin/bash
set -e  # Exit on error
echo $DB_ROOT_PWD 
# Start MariaDB service
if [ -d /var/lib/mysql/$DATABASE ]; then
    
    echo "mariadb already installed"

else
    service mariadb start
    sleep 10

    # Setting up mariadb
    echo "setting up mariadb..."
    echo -e "\nY\n$DB_ROOT_PWD\n$DB_ROOT_PWD\nY\nY\nY\nY" | mariadb-secure-installation
    echo "restarting mariadb..."
    service mariadb restart
    sleep 5

    # Create database Travel if not exists
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
    #mariadb -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';"

    echo "Users created successfully and mariadb service restart"

fi

# Executing CMD from Dockerfile after ending the script
exec "$@"


