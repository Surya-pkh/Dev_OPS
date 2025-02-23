#!/bin/bash

file="$1"  # File name from command-line argument

if [ ! -f "$file" ]; then
  echo "File '$file' not found."
  exit 1
fi

line_count=$(wc -l < "$file")
start_line=5

if [ "$line_count" -lt "$start_line" ]; then
    echo "File has less than 5 lines. No replacement needed."
    exit 0
fi

temp_file=$(mktemp)

{
  head -n "$((start_line - 1))" "$file"  # Copy first 4 lines unchanged
  tail -n "+$start_line" "$file" | while IFS= read -r line; do
    if [[ "$line" == welcome ]]; then
      echo "${line//give/learning}" #replace if line contains welcome
    else
      echo "$line" #print line if it does not contain welcome.
    fi
  done
} > "$temp_file"

mv "$temp_file" "$file"

echo "Replacement completed."
