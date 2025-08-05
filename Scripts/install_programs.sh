#!/usr/bin/env bash

TARGET_DIRECTORY="$HOME/HyDE/Scripts/programs_to_install"

# Check if the directory exists
if [ ! -d "$TARGET_DIRECTORY" ]; then
    echo "Error: Directory '$TARGET_DIRECTORY' not found."
    exit 1
fi

echo "Processing files in: $TARGET_DIRECTORY"
echo "-----------------------------------"

# Loop through all files in the target directory
for file in "$TARGET_DIRECTORY"/*; do
    # Check if it's a regular file (not a directory or special file)
    if [ -f "$file" ]; then
        # Check if the file is executable
        if [ -x "$file" ]; then
            echo "Running: $file"
            # Execute the file
            "$file"
            # You can add a check for the exit status of the executed program if needed
            if [ $? -ne 0 ]; then
                echo "Warning: '$file' exited with a non-zero status (error)."
            fi
            echo "-----------------------------------"
        else
            echo "Skipping (not executable): $file"
        fi
    fi
done

echo "Script finished."
