#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-location.cache
CACHE_TIMEOUT=86400  # Cache for 24 hours

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get location data
LOCATION=$(curl -s ipinfo.io/city)
COUNTRY=$(curl -s ipinfo.io/country)

if [ -z "$LOCATION" ] || [ -z "$COUNTRY" ]; then
    LOCATION_INFO="Location unavailable"
else
    LOCATION_INFO="$LOCATION, $COUNTRY"
fi

echo "$LOCATION_INFO" > "$CACHE_FILE"
echo "$LOCATION_INFO"
