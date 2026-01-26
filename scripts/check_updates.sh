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
# Logic:
# 1. Parse .plugins[]
# 2. Select items where .category starts with '{' (indicating JSON-in-string)
# 3. Parse the category string as JSON to extract tracking info
# Output format: name <tab> author_url <tab> installed_sha <tab> installed_date <tab> current_version <tab> raw_category_json
cat "$MARKETPLACE_FILE" | jq -r '
  .plugins[] 
  | select(.category | tostring | startswith("{")) 
  | [
      .name, 
      .author.url, 
      (.category | fromjson | .tracking.sha), 
      (.category | fromjson | .tracking.date), 
      .version,
      .category
    ] 
  | @tsv
' | while read -r name url installed_sha installed_date current_version raw_category; do
    echo "📦 Checking $name..."
    
    # Extract owner/repo from URL
    repo_path=$(echo "$url" | sed 's/https:\/\/github.com\///')
    
    # Fetch latest commit info
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
        if [[ "$current_version" == "$today_base."* ]]; then
            current_inc=$(echo "$current_version" | awk -F. '{print $3}')
            new_inc=$((current_inc + 1))
            new_version="${today_base}.${new_inc}"
        else
            new_version="${today_base}.0"
        fi
        
        echo "   🆙 Bump version: $current_version -> $new_version"
        
        # Construct new category JSON string with updated tracking info
        # We assume the category JSON has a 'primary' field for the actual category name
        # and a 'tracking' field for our metadata.
        # jq trick: parse raw_category, update fields, then tostring it back
        new_category=$(echo "$raw_category" | jq -c --arg sha "$latest_sha" --arg date "$latest_date" '.tracking.sha = $sha | .tracking.date = $date')
        
        # Update JSON file using a temporary file
        tmp_file=$(mktemp)
        # We need to pass new_category as a STRING, not JSON object
        jq --arg name "$name" \
           --arg ver "$new_version" \
           --arg cat "$new_category" \
           '(.plugins[] | select(.name == $name)) |= (.version = $ver | .category = $cat)' \
           "$MARKETPLACE_FILE" > "$tmp_file" && mv "$tmp_file" "$MARKETPLACE_FILE"

        echo "   💾 Updated $MARKETPLACE_FILE"

        if [ -n "$GITHUB_ENV" ]; then
             echo "UPDATE_FOUND=true" >> $GITHUB_ENV
        fi
    else
        echo "   ✅ Up-to-date"
    fi
    echo "---"
done
