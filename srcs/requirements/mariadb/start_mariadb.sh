#!/bin/bash
set -e  # Exit on error

# Start MariaDB service
#service mariadb start
mysqld --user=mysql --bind-address=0.0.0.0

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
	CREATE DATABASE Travel;
	USE Travel;
	CREATE TABLE Visited_countries (country VARCHAR(50), nb_visits INT, last_visited DATE);
	INSERT INTO Visited_countries (country, nb_visits, last_visited) VALUES ('France', 5, '2024-12-25'), ('Japan', 1, '2019-09-15'), ('USA', 3, '2016-07-01');
	FLUSH PRIVILEGES;
	EXIT;
EOF

	echo "Database setup completed."
fi

exec "$@"
