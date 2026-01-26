#!/bin/bash
set -e

# Configuration
MARKETPLACE_FILE=".claude-plugin/marketplace.json"

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "Error: gh (GitHub CLI) is required but not installed."
    exit 1
fi

if [ ! -f "$MARKETPLACE_FILE" ]; then
    echo "Error: $MARKETPLACE_FILE not found."
    exit 1
fi

echo "🔍 Checking for updates in $MARKETPLACE_FILE..."
echo "---"

# Parse JSON and iterate
# Output format: name <tab> author_url <tab> installed_sha <tab> installed_date <tab> current_version
cat "$MARKETPLACE_FILE" | jq -r '.plugins[] | select(."x-installed-sha" != null) | [."name", ."author"."url", ."x-installed-sha", ."x-installed-date", ."version"] | @tsv' | while read -r name url installed_sha installed_date current_version; do
    echo "📦 Checking $name..."
    
    # Extract owner/repo from URL
    # Handles "https://github.com/owner/repo" -> "owner/repo"
    repo_path=$(echo "$url" | sed 's/https:\/\/github.com\///')
    
    # Fetch latest commit info (SHA and Date) from GitHub API
    # We ask for the committer date in ISO 8601 format
    latest_info=$(gh api "repos/$repo_path/commits/HEAD" --jq '.sha + " " + .commit.committer.date')
    latest_sha=$(echo "$latest_info" | awk '{print $1}')
    latest_date=$(echo "$latest_info" | awk '{print $2}')
    
    echo "   📍 Installed: $installed_sha ($installed_date)"
    echo "   🚀 Latest:    $latest_sha ($latest_date)"
    
    if [ "$installed_sha" != "$latest_sha" ]; then
        echo "   ⚠️  UPDATE AVAILABLE"
        echo "   🔗 Diff: $url/compare/$installed_sha...$latest_sha"
        
        # Calculate new version (YYYY.MM.increment)
        today_base=$(date +'%Y.%-m')
        
        # Check if current version matches this month's pattern
        if [[ "$current_version" == "$today_base."* ]]; then
            # Extract increment number and add 1
            current_inc=$(echo "$current_version" | awk -F. '{print $3}')
            new_inc=$((current_inc + 1))
            new_version="${today_base}.${new_inc}"
        else
            # Start new month count
            new_version="${today_base}.0"
        fi
        
        echo "   🆙 Bump version: $current_version -> $new_version"
        
        # Update JSON file using a temporary file
        tmp_file=$(mktemp)
        jq --arg name "$name" \
           --arg sha "$latest_sha" \
           --arg date "$latest_date" \
           --arg ver "$new_version" \
           '(.plugins[] | select(.name == $name)) |= (.["x-installed-sha"] = $sha | .["x-installed-date"] = $date | .version = $ver)' \
           "$MARKETPLACE_FILE" > "$tmp_file" && mv "$tmp_file" "$MARKETPLACE_FILE"

        echo "   💾 Updated $MARKETPLACE_FILE"

        # Signal for GitHub Actions
        if [ -n "$GITHUB_ENV" ]; then
             echo "UPDATE_FOUND=true" >> $GITHUB_ENV
        fi
    else
        echo "   ✅ Up-to-date"
    fi
    echo "---"
done
