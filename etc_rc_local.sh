#!/bin/bash

# Define the log file path
LOGFILE="/var/log/ppp_monitor.log"

# Start the PPP connection in the background
echo "$(date): Starting PPP connection..." >> $LOGFILE
sudo /usr/bin/pon rnet1 &

# Infinite loop to monitor the PPP connection and ChirpStack IP
while true; do
    # Check if PPP connection is established by checking for the ppp0 interface with an IP address
    if ip addr show ppp0 | grep -q "inet "; then
        echo "$(date): PPP connection is established." >> $LOGFILE

        # Check if the ppp0 monitor script is running
        if ! pgrep -f "ppp0_monitor.sh" > /dev/null; then
            echo "$(date): ppp0_monitor.sh not running. Starting the monitor script..." >> $LOGFILE
            sudo /home/pi/Lora_gateway/ppp0_monitor.sh &
        fi

        # Continuously ping ChirpStack IP
        if ! ping -c 3 -W 5 172.232.126.44 > /dev/null; then
            echo "$(date): ChirpStack IP is not reachable. Restarting GSM module..." >> $LOGFILE
            sudo /usr/bin/python3 /home/pi/Lora_gateway/restart_gsm.py

            # Wait 20 seconds to allow the GSM module to establish a connection
            echo "$(date): Waiting 20 seconds for GSM module to establish a connection..." >> $LOGFILE
            sleep 15
        else
            echo "$(date): ChirpStack IP is reachable." >> $LOGFILE
        fi
    else
        echo "$(date): PPP connection not established, attempting to connect..." >> $LOGFILE
        sudo /usr/bin/pon rnet1

        # Wait a few seconds to allow the PPP connection to establish
        sleep 10

        # Check again if the PPP connection is still not established
        if ! ip addr show ppp0 | grep -q "inet "; then
            echo "$(date): PPP connection failed, restarting GSM module..." >> $LOGFILE
            sudo /usr/bin/python3 /home/pi/Lora_gateway/restart_gsm.py

            # Wait 20 seconds to allow the GSM module to establish a connection
            echo "$(date): Waiting 20 seconds for GSM module to establish a connection..." >> $LOGFILE
            sleep 15
        fi
    fi

    # Sleep for a few seconds before pinging again
    sleep 10
done

exit 0

