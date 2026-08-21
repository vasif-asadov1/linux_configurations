#!/bin/bash

# Ensure the script stops if movies.txt doesn't exist
if [[ ! -f "movies.txt" ]]; then
    echo "Error: movies.txt not found in this directory."
    exit 1
fi

# Read movies.txt line by line
while IFS= read -r line; do
    # Skip empty lines
    if [[ -z "$line" ]]; then continue; fi
    
    # Extract the name (everything before the URL) and trim whitespace
    raw_name=$(echo "$line" | sed 's/: *http.*//')
    
    # Remove numbering like "1. " or "2. " from the name
    clean_name=$(echo "$raw_name" | sed -E 's/^[0-9]+\. *//' | xargs)
    
    # Extract the actual URL
    url=$(echo "$line" | grep -o 'http.*')
    
    echo "======================================================"
    echo "Starting: $clean_name"
    echo "URL: $url"
    
    # Check if the URL is a YouTube link
    if [[ "$url" == *"youtube.com"* ]] || [[ "$url" == *"youtu.be"* ]]; then
        echo "--> YouTube link detected. Routing through yt-dlp + aria2c engine..."
        yt-dlp --downloader aria2c --downloader-args "-x 16 -s 16" -o "${clean_name}.%(ext)s" "$url"
    else
        echo "--> Direct link detected. Using pure aria2c..."
        
        # Extract the extension from the URL (e.g., gets "mp4" from "movie.mp4")
        # and remove any URL parameters if they exist
        filename=$(basename "$url" | cut -d? -f1)
        ext="${filename##*.}"
        
        # Download directly into the current directory using your custom name
        aria2c -x 16 -s 16 -o "${clean_name}.${ext}" "$url"
    fi
    
done < movies.txt

echo "======================================================"
echo "All downloads completed!"
