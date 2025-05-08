#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-humidity.cache
CACHE_TIMEOUT=3600  # Cache for 1 hour

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get weather data using OpenWeatherMap API
API_KEY="b6907d289e10d714a6e88b30761fae22"  # Sample key
CITY_ID=$(curl -s ipinfo.io/loc | awk -F, '{print "lat=" $1 "&lon=" $2}')

# Get humidity
HUMIDITY=$(curl -s "https://api.openweathermap.org/data/2.5/weather?$CITY_ID&appid=$API_KEY&units=metric" | grep -o '"humidity":[^,]*' | cut -d':' -f2)

if [ -z "$HUMIDITY" ]; then
    HUMIDITY="--"
fi

echo "$HUMIDITY" > "$CACHE_FILE"
echo "$HUMIDITY"
