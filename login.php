<?php
session_start();

// Function to read username and password from file
function readCredentialsFromFile($filename) {
    $credentials = [];
    $file = fopen($filename, "r");
    if ($file) {
        while (($line = fgets($file)) !== false) {
            $parts = explode(':', $line);
            if (count($parts) === 2) {
                $credentials[trim($parts[0])] = trim($parts[1]);
            }
        }
        fclose($file);
    }
    return $credentials;
}

$filename = "credentials.txt"; // File containing usernames and passwords

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];

    // Read credentials from file
    $credentials = readCredentialsFromFile($filename);

    // Validate the username and password
    if (isset($credentials[$username]) && $credentials[$username] === $password) {
        // Authentication successful
        $_SESSION["username"] = $username;
        header("Location: /withoutwifi.html"); // Redirect to a welcome page
        exit();
    } else {
        // Authentication failed
        $error_message = "Invalid username or password";
    }
}

// Output the error message
if (isset($error_message)) {
    echo $error_message;
}
?>
