#!/bin/bash

# Kill any running instances of Conky
killall conky 2>/dev/null

# Wait a moment to make sure desktop is loaded
sleep 10

# Start Conky
conky -d

# Optional: Add monitoring to restart if it crashes
while true; do
    if ! pgrep -x "conky" > /dev/null; then
        conky -d
    fi
    sleep 60
done
