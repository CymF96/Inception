<?php
// Database connection details
$host = 'localhost'; // If your DB is in Docker, use the service name from docker-compose
$user = 'username_here'; // Use your actual WordPress DB username
$password = 'password_here'; // Use your actual WordPress DB password
$database = 'database_name_here'; // Use your actual WordPress DB name

// Create connection
$conn = new mysqli($host, $user, $password, $database);

// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
}

echo "<h1>Database Connection Successful!</h1>";

// Get WordPress tables
// Show visited countries
$countries = $conn->query("SELECT country, nb_visits, last_visited FROM Visited_countries ORDER BY last_visited DESC");
	
if ($countries && $countries->num_rows > 0) {
		echo "<h2>Visited Countries:</h2>";
		echo "<table border='1'>";
		echo "<tr><th>Country</th><th>Nomber of Visit</th><th>Visit Date</th><th>";
		while($country = $countries->fetch_assoc()) {
			echo "<tr>";
			echo "<td>" . htmlspecialchars($country["country"]) . "</td>";
			echo "<td>" . $country["nb_visits"] . "</td>";
			echo "<td>" . $country["last_visited"] . "</td>";
			echo "</tr>";
		}
		echo "</table>";
} else {
	echo "<h2>No visited countries found in database.</h2>";
	echo "SQL Error: " . $conn->error;
}

$conn->close();

echo "<p><a href='tanzania/homepage.html'>Visit Our Homepage</a></p>";

?>