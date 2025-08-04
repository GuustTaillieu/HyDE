#!/usr/bin/env bash

# --- Configuration ---
SOURCE_DIR="$HOME/.config"
DEST_REPO_DIR="$HOME/HyDE" # The root of your cloned HyDE repository
DEST_CONFIG_DIR="$DEST_REPO_DIR/Configs/.config" # Where the configs live within the repo

# --- Exclusion List ---
# These patterns are relative to SOURCE_DIR (~/.config/).
# Add any directories or files you want to IGNORE during sync.
EXCLUDE_LIST=(
    "cfg_backups/"
    "parallel/tmp/"
    "nvim/plugged/"           # Example: if you manage vim plugins via a plugin manager
    "code/User/workspaceStorage/" # Example: VS Code workspace state
    # "some_app/cache/"
    "*.log"                   # Exclude all .log files
    "*.cache" 		# Excludes any file/directory ending with .cache.
)

# Convert EXCLUDE_LIST array to rsync-compatible --exclude arguments
EXCLUDE_ARGS=""
for item in "${EXCLUDE_LIST[@]}"; do
    EXCLUDE_ARGS+=" --exclude='$item'"
done
# Remove leading space if EXCLUDE_ARGS is empty (though it won't be with cfg_backups)
EXCLUDE_ARGS=$(echo "$EXCLUDE_ARGS" | xargs) # Cleans up whitespace

# --- Pre-flight Checks ---

# 1. Check and install rsync if not found
if ! command -v rsync &> /dev/null; then
    echo "rsync is not installed. Attempting to install..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm rsync
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm rsync
    else
        echo "Error: Neither pacman nor paru found. Please install rsync manually."
        exit 1
    fi

    if ! command -v rsync &> /dev/null; then
        echo "Error: rsync installation failed. Exiting."
    else
        echo "rsync installed successfully."
    fi
fi

# 2. Ensure the destination repository directory exists
if [ ! -d "$DEST_REPO_DIR" ]; then
    echo "Error: HyDE repository not found at '$DEST_REPO_DIR'."
    echo "Please clone your forked HyDE repository first."
    exit 1
fi

# 3. Ensure the target config directory within the repository exists (create if not)
mkdir -p "$DEST_CONFIG_DIR"

echo "Starting comprehensive configuration sync..."

# --- Dynamic Sync Logic ---
# Find top-level items in SOURCE_DIR and sync them, applying exclusions.
find "$SOURCE_DIR" -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d $'\0' item_path; do
    item_name=$(basename "$item_path")
    # Check if the item_name matches any exclude pattern for top-level items
    SKIP_ITEM=false
    for exclude_pattern in "${EXCLUDE_LIST[@]}"; do
        # For simple top-level directory/file exclusion, we compare item_name
        # The exclude pattern itself might contain '/', so we check the base name
        # For simplicity, if the pattern ends with '/', remove it for direct comparison
        stripped_pattern="${exclude_pattern%/}" # Removes trailing slash if present
        if [[ "$item_name" == "$stripped_pattern" ]]; then
            echo "Skipping excluded item: $item_name"
            SKIP_ITEM=true
            break
        fi
        # If the pattern is a deeper path like "parallel/tmp/", we can't easily check it here
        # based on item_name alone. rsync's --exclude handles this better internally.
        # We will let rsync handle sub-directory exclusions.
    done

    if [ "$SKIP_ITEM" = true ]; then
        continue # Skip to the next item in the find loop
    fi

    echo "Processing: $item_name"
    # Execute rsync with the dynamically generated exclude arguments
    # The eval is needed because $EXCLUDE_ARGS is a string that needs to be parsed by bash
    # as separate arguments. Use with caution, but it's common for rsync's --exclude.
    eval rsync -av --delete-after "$item_path" "$DEST_CONFIG_DIR/" "$EXCLUDE_ARGS"
done

echo "Configuration sync complete."

# --- Git Operations ---
# Navigate to the HyDE repository directory
cd "$DEST_REPO_DIR" || { echo "Error: Could not navigate to HyDE repository at '$DEST_REPO_DIR'. Exiting."; exit 1; }

echo "Adding changes to Git..."
# Use Configs/.config/ to be specific about what we're adding
git add Configs/.config/ || { echo "Error: git add failed. Check for untracked files or permissions."; exit 1; }

# Generate commit message with current date and time
COMMIT_MESSAGE="Sync dotfiles - $(date '+%Y-%m-%d %H:%M:%S %Z')"

echo "Committing changes..."
# Use || { ...; exit 1; } for robust error handling
git commit -m "$COMMIT_MESSAGE" || { echo "Error: Git commit failed. No changes to commit or other issue."; exit 1; }

echo "Pushing to remote..."
git push || { echo "Error: Git push failed. Please resolve manually (e.g., rebase, pull)."; exit 1; }

echo "Script finished."
