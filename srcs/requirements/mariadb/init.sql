-- Secure Installation of Mariadb with removing unecessary test elements
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

-- Creating 2 users: Administrator and RandomUser
GRANT ALL ON *.* TO '$DB_ADMIN_ID'@'localhost' IDENTIFIED BY '$DB_ADMIN_PWD' WITH GRANT OPTION;
-- UPDATE mysql.user SET Host='localhost' WHERE User='$DB_ADMIN_ID';
GRANT SELECT, INSERT, UPDATE ON *.* TO 'RandomUser'@'localhost' IDENTIFIED BY 'D@ckerUzeR2025+';

-- Create Example Data
CREATE DATABASE Travel;
USE Travel;
CREATE TABLE Visited_countries ((country VARCHAR(50)), nb_visits INT, last_visited DATE);
INSERT INTO Visited_countries (country, nb_visits, last_visisted) VALUES ('France', 5, '2024-12-25'), ('Japan', 1, '2019-09-15'), ('USA', 3, '2016-07-01');

-- exit mariadb
FLUSH PRIVILEGES;
EXIT;