#!/bin/bash

# Configuration
HOOKS_DIR="hooks"
AVAILABLE_HOOKS=(
    "pre-push-rebase:Rebase base branch before push"
)

# Ensure we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: This script must be run from the root of a git repository"
    exit 1
fi

# Get git hooks path
GIT_HOOKS_PATH=$(git config core.hooksPath)
if [ -z "$GIT_HOOKS_PATH" ]; then
    GIT_HOOKS_PATH="$(pwd)/.git/hooks"
fi
mkdir -p "$GIT_HOOKS_PATH"

# Display available hooks
echo "📋 Available Git Hooks:"
for i in "${!AVAILABLE_HOOKS[@]}"; do
    IFS=':' read -r file description <<<"${AVAILABLE_HOOKS[$i]}"
    echo "$((i + 1))) $description"
done
echo "q) Quit"

# Get user selection
while true; do
    read -p "Select a hook to install (1-${#AVAILABLE_HOOKS[@]}, q to quit): " choice

    # Handle quit
    if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
        echo "Exiting..."
        exit 0
    fi

    # Validate input
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#AVAILABLE_HOOKS[@]}" ]; then
        echo "❌ Invalid option. Please try again."
        continue
    fi

    # Get selected hook info
    index=$((choice - 1))
    IFS=':' read -r hook_file hook_description <<<"${AVAILABLE_HOOKS[$index]}"

    # Install the selected hook
    echo "Installing: $hook_description"

    # Handle hook-specific configuration
    if [[ "$hook_file" == "pre-push-rebase" ]]; then
        read -p "Enter base branch name [develop]: " BASE_BRANCH
        BASE_BRANCH=${BASE_BRANCH:-develop}

        # Read and process the hook template
        if [ -f "$HOOKS_DIR/$hook_file" ]; then
            HOOK_CONTENT=$(cat "$HOOKS_DIR/$hook_file")
            HOOK_CONTENT=${HOOK_CONTENT/__BASE_BRANCH__/$BASE_BRANCH}

            # Install the hook
            echo "$HOOK_CONTENT" >"$GIT_HOOKS_PATH/pre-push"
            chmod +x "$GIT_HOOKS_PATH/pre-push"

            if [ -x "$GIT_HOOKS_PATH/pre-push" ]; then
                echo "✅ Hook installed successfully!"
                echo "🔍 Location: $GIT_HOOKS_PATH/pre-push"
                break
            else
                echo "❌ Failed to install hook"
                exit 1
            fi
        else
            echo "❌ Hook template not found: $HOOKS_DIR/$hook_file"
            exit 1
        fi
    fi
done
