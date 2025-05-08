#!/bin/bash
# Save these scripts in ~/.conky/ directory and make them executable with:
# chmod +x ~/.conky/weather-*.sh

# Create the directory if it doesn't exist
mkdir -p ~/.conky/cache

# Script 1: ~/.conky/weather-icon.sh
cat > ~/.conky/weather-icon.sh << 'EOF'
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
EOF

# Script 2: ~/.conky/weather-temp.sh
cat > ~/.conky/weather-temp.sh << 'EOF'
#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-temp.cache
CACHE_TIMEOUT=3600  # Cache for 1 hour

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get weather data using OpenWeatherMap API
API_KEY="b6907d289e10d714a6e88b30761fae22"  # Sample key
CITY_ID=$(curl -s ipinfo.io/loc | awk -F, '{print "lat=" $1 "&lon=" $2}')

# Get temperature
TEMP=$(curl -s "https://api.openweathermap.org/data/2.5/weather?$CITY_ID&appid=$API_KEY&units=metric" | grep -o '"temp":[^,]*' | cut -d':' -f2 | cut -d'.' -f1)

if [ -z "$TEMP" ]; then
    TEMP="--"
fi

echo "$TEMP" > "$CACHE_FILE"
echo "$TEMP"
EOF

# Script 3: ~/.conky/weather-desc.sh
cat > ~/.conky/weather-desc.sh << 'EOF'
#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-desc.cache
CACHE_TIMEOUT=3600  # Cache for 1 hour

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get weather data using OpenWeatherMap API
API_KEY="b6907d289e10d714a6e88b30761fae22"  # Sample key
CITY_ID=$(curl -s ipinfo.io/loc | awk -F, '{print "lat=" $1 "&lon=" $2}')

# Get weather description
DESC=$(curl -s "https://api.openweathermap.org/data/2.5/weather?$CITY_ID&appid=$API_KEY&units=metric" | grep -o '"description":"[^"]*"' | head -1 | cut -d'"' -f4 | sed 's/\b\(.\)/\u\1/g')

if [ -z "$DESC" ]; then
    DESC="Weather data unavailable"
fi

echo "$DESC" > "$CACHE_FILE"
echo "$DESC"
EOF

# Script 4: ~/.conky/weather-location.sh
cat > ~/.conky/weather-location.sh << 'EOF'
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
EOF

# Script 5: ~/.conky/weather-humidity.sh
cat > ~/.conky/weather-humidity.sh << 'EOF'
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
EOF

# Script 6: ~/.conky/weather-wind.sh
cat > ~/.conky/weather-wind.sh << 'EOF'
#!/bin/bash
CACHE_FILE=~/.conky/cache/weather-wind.cache
CACHE_TIMEOUT=3600  # Cache for 1 hour

# If cache exists and is less than timeout, use it
if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TIMEOUT ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Get weather data using OpenWeatherMap API
API_KEY="b6907d289e10d714a6e88b30761fae22"  # Sample key
CITY_ID=$(curl -s ipinfo.io/loc | awk -F, '{print "lat=" $1 "&lon=" $2}')

# Get wind speed
WIND=$(curl -s "https://api.openweathermap.org/data/2.5/weather?$CITY_ID&appid=$API_KEY&units=metric" | grep -o '"speed":[^,]*' | cut -d':' -f2)

if [ -z "$WIND" ]; then
    WIND="--"
fi

echo "$WIND" > "$CACHE_FILE"
echo "$WIND"
EOF

# Make all scripts executable
chmod +x ~/.conky/weather-*.sh

echo "All weather scripts have been created in ~/.conky/ directory and made executable."
echo "You'll need to install the Weather Icons font for the weather symbols to display properly."
