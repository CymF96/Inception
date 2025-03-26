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
$result = $conn->query("SHOW TABLES");

if ($result->num_rows > 0) {
    echo "<h2>WordPress Tables:</h2>";
    echo "<ul>";
    while($row = $result->fetch_row()) {
        echo "<li>" . $row[0] . "</li>";
    }
    echo "</ul>";
    
    // Show visited countries
    // This assumes you have a table named 'visited_countries' with columns 'id', 'country_name', and 'visit_date'
    // You'll need to adjust this query based on your actual table structure
    $countries = $conn->query("SELECT id, country_name, visit_date, notes FROM visited_countries ORDER BY visit_date DESC");
    
    if ($countries && $countries->num_rows > 0) {
        echo "<h2>Visited Countries:</h2>";
        echo "<table border='1'>";
        echo "<tr><th>ID</th><th>Country</th><th>Visit Date</th><th>Notes</th></tr>";
        while($country = $countries->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $country["id"] . "</td>";
            echo "<td>" . htmlspecialchars($country["country_name"]) . "</td>";
            echo "<td>" . $country["visit_date"] . "</td>";
            echo "<td>" . htmlspecialchars($country["notes"]) . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "<h2>No visited countries found in database.</h2>";
        echo "SQL Error: " . $conn->error;
    }
} else {
    echo "No tables found in database.";
}

echo "<p><a href='tanzania/homepage.html'>Visit Our Homepage</a></p>";

$conn->close();
?>