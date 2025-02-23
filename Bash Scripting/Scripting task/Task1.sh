#!/bin/bash

# Function to get HTTP status code
get_http_status() {
  local url="$1"
  local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  echo "$status_code"
}

# Function to interpret common HTTP status codes
interpret_status() {
  local status_code="$1"
  case "$status_code" in
    200) echo "200 OK - Request succeeded.";;
    301) echo "301 Moved Permanently - The resource has moved.";;
    302) echo "302 Found - The resource has moved temporarily.";;
    400) echo "400 Bad Request - The server cannot process the request.";;
    401) echo "401 Unauthorized - Authentication is required.";;
    403) echo "403 Forbidden - Access is denied.";;
    404) echo "404 Not Found - The resource doesn't exist.";;
    500) echo "500 Internal Server Error - Server encountered an error.";;
    502) echo "502 Bad Gateway - Invalid response from upstream server.";;
    503) echo "503 Service Unavailable - Server is temporarily unavailable.";;
    *) echo "Unknown or less common status code: $status_code";;
  esac
}

# Main script
url="http://guvi.in"
status=$(get_http_status "$url")

echo "HTTP Status Code for $url: $status"
interpret_status "$status"

if [[ "$status" -ge 200 && "$status" -lt 300 ]]; then
  echo "Success!"
else
  echo "Failure!"
fi
