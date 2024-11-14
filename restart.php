<?php
// Function to restart the GSM module using the Python script
function restart_gsm_module() {
    // Path to the Python script
    $pythonScript = '/home/pi/Lora_gateway/restart_gsm.py ';
    
    // Execute the Python script
    $output = shell_exec('sudo  /usr/bin/python3 '.escapeshellarg($pythonScript).' 2>&1');
    
    // Check if the output contains any success message or log
    if (strpos($output, 'GSM module has been reset') !== false) {
        echo "Script executed successfully!<br>";
    } else {
        echo "Script execution failed or did not produce expected output.<br>";
    }

    // Display output for debugging
    echo "<pre>$output</pre>";
}

// Restart the GSM module and return the response to the user
echo restart_gsm_module();

?>













