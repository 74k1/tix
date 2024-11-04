#!/bin/bash

# Check if git filter-repo is installed
if ! command -v git-filter-repo &> /dev/null
then
    echo "git filter-repo is not installed. Please install it from https://github.com/newren/git-filter-repo/"
    exit 1
fi

# Define the email mappings
declare -A email_map=(
    ["git@temporamail.net"]="git.t@betsumei.com"
    ["74k1@pm.me"]="git.t@betsumei.com"
    ["49000471+74k1@users.noreply.github.com"]="git.t@betsumei.com"
    ["tim.raschle@adcubum.com"]="git.t@betsumei.com"
    ["tim.raschle@adm-lt2qpcgg7g.adcubum-internal"]="git.t@betsumei.com"
)

# Create a temporary file for the email mapping
temp_file=$(mktemp)

# Write the email mappings to the temporary file
for old_email in "${!email_map[@]}"; do
    echo "${old_email}=${email_map[$old_email]}" >> "$temp_file"
done

# Run git filter-repo
git filter-repo --email-callback "
    return b'git.t@betsumei.com'
" --name-callback "
    return b'74k1'
" --mailmap "$temp_file"

# Remove the temporary file
rm "$temp_file"

echo "Email addresses and names have been updated in the repository."
