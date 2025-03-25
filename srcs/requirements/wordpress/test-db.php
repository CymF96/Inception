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
    
    // Show posts example
    $posts = $conn->query("SELECT ID, post_title, post_date FROM wp_posts WHERE post_status='publish' LIMIT 10");
    
    if ($posts->num_rows > 0) {
        echo "<h2>Recent Posts:</h2>";
        echo "<table border='1'>";
        echo "<tr><th>ID</th><th>Title</th><th>Date</th></tr>";
        while($post = $posts->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $post["ID"] . "</td>";
            echo "<td>" . htmlspecialchars($post["post_title"]) . "</td>";
            echo "<td>" . $post["post_date"] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    }
} else {
    echo "No tables found in database.";
}

$conn->close();
?>