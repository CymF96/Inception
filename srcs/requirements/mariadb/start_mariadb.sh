#!/bin/bash
set -e  # Exit on error

# Start MySQL service


id mysql
cat /var/run/mysqld/mysqld.sock
service mysql start
# Create database Travel if not exists
echo "Creating new database $DATABASE"
mysql -e "CREATE DATABASE IF NOT EXISTS $DATABASE;"

# Create the table Visited_countries
echo "Creating elements inside $DATABASE"
mysql -e "USE $DATABASE; CREATE TABLE IF NOT EXISTS Visited_countries (
    country VARCHAR(50),
    nb_visits INT,
    last_visited DATE
);"

# Insert initial data into Visited_countries table
mysql -e "USE $DATABASE; INSERT INTO Visited_countries (country, nb_visits, last_visited) 
VALUES 
    ('France', 5, '2024-12-25'),
    ('Japan', 1, '2019-09-15'),
    ('USA', 3, '2016-07-01');"

# Create admin user with root privileges
echo "Creating new users $DB_ADMIN_ID && $DB_ID"
mysql -e "CREATE USER IF NOT EXISTS '${DB_ADMIN_ID}'@'%' IDENTIFIED BY '${DB_ADMIN_PWD}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_ADMIN_ID}'@'%' WITH GRANT OPTION;"

# Create normal user
mysql -e "CREATE USER IF NOT EXISTS '${DB_ID}'@'%' IDENTIFIED BY '${DB_PWD}';"
mysql -e "GRANT SELECT, INSERT, UPDATE ON ${DATABASE}.* TO '${DB_ID}'@'%';"

# Flush privileges to apply changes
mysql -e "FLUSH PRIVILEGES;"

# Shut down MySQL service (you may need to pass root user credentials)
mysqladmin -u root -p"${mysql_root_password}" shutdown

echo "Users created successfully and MySQL service shut down."

exec "$@"

##!/bin/bash
#set -e
#
## Ensure the data directory is initialized
#if [ ! -d "/var/lib/mysql/mysql" ]; then
#    echo "Initializing database..."
#    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
#
#    echo "Starting MariaDB for initial setup..."
#    mysqld_safe --bind-address=0.0.0.0 &
#
#    # Wait for MariaDB to be ready
#    sleep 5
#    until mariadb -u root -e "SELECT 1" &>/dev/null; do
#        echo "Waiting for MariaDB to start..."
#        sleep 2
#    done
#
#    echo "Initializing database tables..."
#    mariadb -u root <<EOF
#    DELETE FROM mysql.user WHERE User='';
#    DROP DATABASE IF EXISTS test;
#    CREATE DATABASE IF NOT EXISTS $DATABASE;
#    GRANT ALL ON $DATABASE.* TO '$DB_ADMIN_ID'@'localhost' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;
#    GRANT SELECT, INSERT, UPDATE ON $DATABASE.* TO '$DB_ID'@'localhost' IDENTIFIED BY '$DB_PWD';
#    USE $DATABASE;
#    
#    CREATE TABLE IF NOT EXISTS Visited_countries (
#        country VARCHAR(50),
#        nb_visits INT,
#        last_visited DATE
#    );
#
#    INSERT INTO Visited_countries (country, nb_visits, last_visited) 
#    VALUES ('France', 5, '2024-12-25'), ('Japan', 1, '2019-09-15'), ('USA', 3, '2016-07-01');
#
#    FLUSH PRIVILEGES;
#EOF
#
#    echo "Database setup completed."
#fi
#
## Start MariaDB in the foreground
#exec mysqld_safe --bind-address=0.0.0.0

