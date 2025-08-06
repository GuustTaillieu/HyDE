#!/usr/bin/env bash

# --- Configuration ---
SOURCE_DIR="$HOME/.config"
DEST_REPO_DIR="$HOME/HyDE" # The root of your cloned HyDE repository
DEST_CONFIG_DIR="$DEST_REPO_DIR/Configs/.config" # Where the configs live within the repo

# --- Inclusion List ---
# IMPORTANT: ONLY items (directories or files) listed here will be synced.
# These paths are relative to SOURCE_DIR (~/.config/).
# Ensure you list the top-level directories/files you want to back up.
#
# DO NOT include a leading '/' (e.g., '/hypr/'). Paths are relative.
INCLUDE_LIST=(
	"Kvantum/"
	"VSCodium/"
	"cava/"
	"dunst/"
	"fastfetch/"
	"fish/"
	"gtk-3.0/"
	"gtk-4.0/"
	"hyde/"
	"hypr/"
	"kde.org/"
	"kitty/"
	"menus/"
	"nwg-look/"
	"pulse/"
	"qt5ct/"
	"qt6ct/"
	"rofi/"
	"session/"
	"spicetify/"
	"starship/"
	"swaylock/"
	"systemd/"
	"vim/"
	"waybar/"
	"wlogout/"
	"zsh/"
	"arkrc"
	"baloofileinformationrc"
	"baloofilerc"
	"code-flags.conf"
	"codium-flags.conf"
	"dolphinrc"
	"electron-flags.conf"
	"kdeglobals"
	"libinput-gestures.conf"
	"mimeapps.list"
	"pavucontrol.ini"
	"spotify-flags.conf"
	"user-dirs.dirs"
	"user-dirs.locale"
)

# --- Exclusion List ---
# These patterns are relative to the *individual item being synced*.
# They apply to paths *within* the items specified in INCLUDE_LIST.
# Use this for subdirectories or files within your included configs that
# you still want to explicitly ignore (e.g., caches, logs, temporary files).
#
EXCLUDE_LIST=(
    "cache/"
    "tmp/"
    "*.log"
    "*.cache"
    "session/"
    "user_data/"
    "runtime/"
    "nvim/"
    "vesktop/"
    "spotify/"
    # WARNING - Important to EXCLUDE all programs with user details like passwords etc.!!
)


# Convert EXCLUDE_LIST array to rsync-compatible --exclude arguments
EXCLUDE_ARGS=""
for item in "${EXCLUDE_LIST[@]}"; do
    EXCLUDE_ARGS+=" --exclude='$item'"
done
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

echo "Starting selective configuration sync (add and update only, maintaining structure)..."

# --- Selective Sync Logic ---
# Iterate only over the items explicitly defined in INCLUDE_LIST.
for item_to_sync in "${INCLUDE_LIST[@]}"; do
    # Form the full source path.
    # We explicitly remove the trailing slash from item_to_sync for the source argument
    # to rsync. This ensures the directory/file itself is copied into the destination,
    # rather than just its contents (if it's a directory).
    SOURCE_ITEM_PATH="$SOURCE_DIR/${item_to_sync%/}" # Removes trailing slash if present

    if [ -e "$SOURCE_ITEM_PATH" ]; then # Check if the source item actually exists
        echo "Processing: $SOURCE_ITEM_PATH"
        # The rsync command:
        # -av: archive mode (preserves permissions, timestamps, etc.), verbose
        # "$SOURCE_ITEM_PATH": The item (file or directory) from ~/.config to copy.
        #                     Crucially, this path does NOT have a trailing slash,
        #                     so rsync copies the item ITSELF.
        # "$DEST_CONFIG_DIR/": The destination directory. The trailing slash here
        #                      means "copy into this directory".
        # "$EXCLUDE_ARGS": Any defined exclusions. These are applied *within* the
        #                  copied item.
        eval rsync -av "$SOURCE_ITEM_PATH" "$DEST_CONFIG_DIR/" "$EXCLUDE_ARGS"
    else
        echo "Warning: Source item '$SOURCE_ITEM_PATH' does not exist in your ~/.config. Skipping."
    fi
done

echo "Selective configuration sync complete."


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
