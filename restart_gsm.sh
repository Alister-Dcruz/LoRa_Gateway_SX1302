import RPi.GPIO as GPIO
import time
import os  # Import the os module to execute system commands

RESET_PIN = 21

# Suppress warnings
GPIO.setwarnings(False)

# Set BCM numbering
GPIO.setmode(GPIO.BCM)

# Set GPIO21 as an output pin and initialize it to HIGH
GPIO.setup(RESET_PIN, GPIO.OUT, initial=GPIO.HIGH)

try:
    # Set pin low for 2 seconds
    GPIO.output(RESET_PIN, GPIO.LOW)
    time.sleep(2)

    # Set pin back to high and keep it high
    GPIO.output(RESET_PIN, GPIO.HIGH)

    # Add a log message or print statement to confirm the reset
    print("GSM module has been reset. Now rebooting the Raspberry Pi...")

    # Reboot the Raspberry Pi
    os.system('sudo reboot')  # Execute the reboot command
except Exception as e:
    print(f"An error occurred: {e}")
finally:
    # Do NOT call GPIO.cleanup() to keep the pin in the HIGH state
    pass

