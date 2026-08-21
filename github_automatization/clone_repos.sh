#!/bin/bash

FILE="my_github_repos.txt"

if [[ ! -f "$FILE" ]]; then
    echo "Error: $FILE not found! Make sure you are in the ~/Github/ directory."
    exit 1
fi

# Find the total number of repos by skipping empty lines
TOTAL_REPOS=$(grep -c "[^[:space:]]" "$FILE")
CURRENT=0

# Custom Progress Bar function to keep the terminal clean
draw_progress_bar() {
    local current=$1
    local total=$2
    local width=40
    local percent=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    local message=$3
    
    printf "\rProgress: ["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%% (%d/%d) - %s\e[K" "$percent" "$current" "$total" "$message"
}

echo "Total of $TOTAL_REPOS repos to clone..."
echo ""

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    # Clean Windows carriage returns (\r) and skip empty lines
    line=$(echo "$raw_line" | tr -d '\r')
    if [[ -z "$line" ]]; then continue; fi

    # Split the line into parts using ': ' and '. ' with Awk logic
    URL=$(echo "$line" | awk -F': ' '{print $2}')
    FOLDER_NAME=$(echo "$line" | awk -F': ' '{print $1}' | awk -F'. ' '{print $2}')

    draw_progress_bar $CURRENT $TOTAL_REPOS "Processing: $FOLDER_NAME"
    
    # Skip cloning if the folder already exists (Prevents errors)
    if [ -d "$FOLDER_NAME" ]; then
        draw_progress_bar $CURRENT $TOTAL_REPOS "Skipped: $FOLDER_NAME (Already exists)"
    else
        # The -q parameter hides the git clone output, preventing the progress bar from breaking
        git clone -q "$URL" "$FOLDER_NAME"
    fi

    CURRENT=$((CURRENT + 1))
    draw_progress_bar $CURRENT $TOTAL_REPOS "Completed: $FOLDER_NAME"

done < "$FILE"

echo -e "\n\n✅ All repos successfully cloned!"
