#!/bin/bash

set -e  # Exit on error

echo "🔍 Checking environment variables..."
if [ -f .env ]; then
    source .env
fi

# Ask user for authentication method
echo "🔹 Select authentication method: (1) PAT, (2) SSH"
read -r AUTH_METHOD

if [ "$AUTH_METHOD" == "1" ]; then
    if [ -z "$GITHUB_PAT" ]; then
        echo "❌ Error: GITHUB_PAT not set!"
        exit 1
    else
        echo "   ➜ GITHUB_PAT: ghp_****** (Hidden for security)"
    fi
    USE_SSH=false
elif [ "$AUTH_METHOD" == "2" ]; then
    USE_SSH=true
    echo "🔑 Using SSH authentication"
else
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

MANIFEST_FILE="manifest/manifest.xml"
if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ Error: Manifest file not found!"
    exit 1
fi

# Select Environment
echo "🔹 Select an environment: dev, prod, staging"
read -r ENVIRONMENT
echo "🛠️ Selected environment: $ENVIRONMENT"

# Extract Repositories
XML_CONTENT=$(awk "/<environment name=\"$ENVIRONMENT\">/,/<\/environment>/" "$MANIFEST_FILE")

echo "🔍 Extracted XML for $ENVIRONMENT:"
echo "$XML_CONTENT"

# Extract only <repo> lines
REPO_LINES=$(echo "$XML_CONTENT" | grep "<repo")

if [ -z "$REPO_LINES" ]; then
    echo "⚠️ No repositories found for environment '$ENVIRONMENT'."
    exit 1
fi

# Process Each Repository
echo "🚀 Fetching repositories..."
while IFS= read -r line; do
    REPO_NAME=$(echo "$line" | sed -n 's/.*name=\"\([^\"]*\)\".*/\1/p')
    REPO_URL=$(echo "$line" | sed -n 's/.*url=\"\([^\"]*\)\".*/\1/p')
    BRANCH=$(echo "$line" | sed -n 's/.*branch=\"\([^\"]*\)\".*/\1/p')
    DEST_DIR=$(echo "$line" | sed -n 's/.*path=\"\([^\"]*\)\".*/\1/p')

    echo "🔍 Processing repository: $REPO_NAME"
    
    if [ "$USE_SSH" == "true" ]; then
        REPO_URL="git@github.com:${REPO_URL#https://github.com/}"
        echo "🔗 URL: $REPO_URL (Using SSH)"
    else
        REPO_URL="https://${GITHUB_PAT}${REPO_URL#https://}"
        echo "🔗 URL: $REPO_URL (Using PAT)"
    fi
    
    echo "📂 Repo: $REPO_NAME → $DEST_DIR"
    echo "🌿 Branch: $BRANCH"

    mkdir -p "$DEST_DIR"

    if [ -d "$DEST_DIR/.git" ]; then
        echo "🔄 Updating $REPO_NAME..."
        git -C "$DEST_DIR" fetch origin "$BRANCH"
        git -C "$DEST_DIR" checkout "$BRANCH"
        git -C "$DEST_DIR" pull origin "$BRANCH"
    else
        echo "📥 Cloning $REPO_NAME..."
        if git clone --branch "$BRANCH" --recurse-submodules "$REPO_URL" "$DEST_DIR"; then
            echo "✅ Successfully cloned $REPO_NAME"
        else
            echo "❌ Error cloning $REPO_NAME! Check your authentication method."
            exit 1
        fi
    fi

    # Initialize and update submodules
    echo "🔄 Updating submodules for $REPO_NAME..."
    git -C "$DEST_DIR" submodule update --init --recursive

    # Ensure submodules track the correct branch instead of being locked to a commit
    echo "🔄 Ensuring submodules track the latest branch..."
    git -C "$DEST_DIR" submodule foreach --recursive "git checkout main && git pull origin main"

done <<< "$REPO_LINES"

echo "✅ All repositories and submodules for '$ENVIRONMENT' processed successfully!"
