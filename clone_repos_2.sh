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
    # \e[K clears the rest of the line so old text doesn't overlap
    printf "] %d%% (%d/%d) - %s\e[K" "$percent" "$current" "$total" "$message"
}

echo "Total of $TOTAL_REPOS repos to clone..."
echo ""

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    # Clean Windows carriage returns (\r) and skip empty lines
    line=$(echo "$raw_line" | tr -d '\r')
    if [[ -z "$line" ]]; then continue; fi

    # BULLETPROOF PARSING:
    # 1. Remove the numbering at the start (e.g., "1. ")
    clean_line=$(echo "$line" | sed -E 's/^[0-9]+\.[[:space:]]*//')
    # 2. Extract folder name (grabs everything before the first colon or space)
    FOLDER_NAME=$(echo "$clean_line" | awk -F'[: ]' '{print $1}')
    # 3. Extract URL (looks specifically for anything starting with git@ or https://)
    URL=$(echo "$line" | grep -oE '(git@|https://)[^ ]+')

    # If parsing completely fails and finds no URL, skip to prevent instant crashes
    if [[ -z "$URL" ]]; then
        continue
    fi

    draw_progress_bar $CURRENT $TOTAL_REPOS "Processing: $FOLDER_NAME"

    if [ -d "$FOLDER_NAME" ]; then
        draw_progress_bar $CURRENT $TOTAL_REPOS "Skipped: $FOLDER_NAME (Already exists)"
    else
        # 2>/dev/null completely hides any git errors so the progress bar never breaks
        git clone -q "$URL" "$FOLDER_NAME" 2>/dev/null
    fi

    CURRENT=$((CURRENT + 1))
    draw_progress_bar $CURRENT $TOTAL_REPOS "Completed: $FOLDER_NAME"

done < "$FILE"

echo -e "\n\n✅ All repos successfully cloned!"
