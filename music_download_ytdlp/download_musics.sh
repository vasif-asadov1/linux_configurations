#!/bin/bash

# Check if musics.txt exists
if [[ ! -f "musics.txt" ]]; then
    echo "Error: musics.txt not found in this directory."
    exit 1
fi

# Read musics.txt line by line
while IFS= read -r line; do
    # Skip empty lines
    if [[ -z "$line" ]]; then continue; fi
    
    # Extract the name and the URL
    raw_name=$(echo "$line" | sed 's/: *http.*//')
    clean_name=$(echo "$raw_name" | sed -E 's/^[0-9]+\. *//' | xargs)
    url=$(echo "$line" | grep -o 'http.*')
    
    echo "======================================================"
    echo "Processing: $clean_name"
    
    # Check if it is a playlist (contains "list=")
    if [[ "$url" == *"list="* ]]; then
        echo "--> Playlist detected. Creating folder '$clean_name'..."
        mkdir -p "$clean_name"
        
        # Download using cookies to bypass 403 Forbidden
        yt-dlp --cookies-from-browser firefox --extract-audio --audio-format mp3 -o "${clean_name}/%(title)s.%(ext)s" "$url"
    else
        echo "--> Single video detected. Downloading to main directory..."
        
        # Download single video using cookies to bypass 403 Forbidden
        yt-dlp --cookies-from-browser firefox --extract-audio --audio-format mp3 -o "${clean_name}.%(ext)s" "$url"
    fi
    
done < musics.txt

echo "======================================================"
echo "All musics successfully downloaded and converted to MP3!"
