-- Create Example Data
CREATE DATABASE Travel;
USE Travel;
CREATE TABLE Visited_countries (country VARCHAR(50), nb_visits INT, last_visited DATE);
INSERT INTO Visited_countries (country, nb_visits, last_visited) VALUES ('France', 5, '2024-12-25'), ('Japan', 1, '2019-09-15'), ('USA', 3, '2016-07-01');

-- exit mariadb
EXIT