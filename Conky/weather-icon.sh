#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-icon.cache
CACHE_TIMEOUT=3600  # Cache for 1 hour

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get weather data using OpenWeatherMap API
# You need to create a free account at openweathermap.org and replace YOUR_API_KEY
API_KEY="b6907d289e10d714a6e88b30761fae22"  # Sample key, low rate limit but works for demo
CITY_ID=$(curl -s ipinfo.io/loc | awk -F, '{print "lat=" $1 "&lon=" $2}')

# Get weather data
WEATHER_DATA=$(curl -s "https://api.openweathermap.org/data/2.5/weather?$CITY_ID&appid=$API_KEY&units=metric")
WEATHER_ID=$(echo "$WEATHER_DATA" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

# Map weather code to Weather Icons font
case $WEATHER_ID in
    2[0-9][0-9]) ICON="";;  # Thunderstorm
    3[0-9][0-9]) ICON="";;  # Drizzle
    5[0-9][0-9]) ICON="";;  # Rain
    6[0-9][0-9]) ICON="";;  # Snow
    800) ICON="";;         # Clear
    801) ICON="";;         # Few clouds
    802) ICON="";;         # Scattered clouds
    803|804) ICON="";;     # Broken/overcast clouds
    7[0-9][0-9]) ICON="";;  # Atmosphere (fog, mist, etc)
    900) ICON="";;         # Tornado
    *) ICON="";;           # Default
esac

# For debugging, if Weather Icons font is missing, use text
if [ -z "$ICON" ]; then
    ICON="?"
fi

echo "$ICON" > "$CACHE_FILE"
echo "$ICON"
