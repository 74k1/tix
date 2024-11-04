{ lib
, writeShellApplication
, git-filter-repo
}:

writeShellApplication {
  name = "git-email-filter";
  runtimeInputs = [ git-filter-repo ];
  
  text = ''
    usage() {
      echo "Usage: git-email-filter [--force]"
      echo ""
      echo "This tool rewrites git history to standardize commit author names and emails."
      echo ""
      echo "For safety reasons, this tool should be run on a fresh clone of your repository."
      echo "Steps to use:"
      echo "1. Create a fresh clone: git clone <your-repo-url> fresh-clone"
      echo "2. cd fresh-clone"
      echo "3. Run this tool: git-email-filter"
      echo ""
      echo "Options:"
      echo "  --force    Skip safety checks (USE WITH CAUTION - may result in data loss)"
      echo ""
      exit 1
    }

    # Process arguments
    FORCE=0
    while [[ $# -gt 0 ]]; do
      case $1 in
        --force)
          FORCE=1
          shift
          ;;
        -h|--help)
          usage
          ;;
        *)
          echo "Unknown option: $1"
          usage
          ;;
      esac
    done

    # Safety checks
    if [ $FORCE -eq 0 ]; then
      # Check if repo is dirty
      if ! git diff-index --quiet HEAD --; then
        echo "Error: Git repository has uncommitted changes."
        echo "Please commit or stash your changes first, or use --force to override."
        exit 1
      fi

      # Check if this looks like a fresh clone
      if [ -d ".git/refs/remotes" ] && [ "$(find .git/refs/remotes -type f | wc -l)" -gt 1 ]; then
        echo "Error: This repository has multiple remotes or branches."
        echo "For safety, please use a fresh clone (or use --force to override)."
        echo ""
        echo "Recommended steps:"
        echo "1. git clone <your-repo-url> fresh-clone"
        echo "2. cd fresh-clone"
        echo "3. git-email-filter"
        exit 1
      fi
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

    # Write the email mappings to the temporary file in proper git-mailmap format
    for old_email in "''${!email_map[@]}"; do
        echo "74k1 <''${email_map[$old_email]}> <$old_email>" >> "$temp_file"
    done

    # Run git filter-repo
    FILTER_REPO_ARGS="--email-callback \"return b'git.t@betsumei.com'\" --name-callback \"return b'74k1'\" --mailmap \"$temp_file\""
    
    if [ $FORCE -eq 1 ]; then
        FILTER_REPO_ARGS="$FILTER_REPO_ARGS --force"
    fi

    eval "git filter-repo $FILTER_REPO_ARGS"

    # Remove the temporary file
    rm "$temp_file"

    if [ $? -eq 0 ]; then
        echo "Success! Email addresses and names have been updated in the repository."
        echo ""
        echo "Next steps:"
        echo "1. Verify the changes: git log"
        echo "2. Push to remote (if desired): git push origin --force"
    fi
  '';

  meta = with lib; {
    description = "Git history email and name standardization tool";
    mainProgram = "git-email-filter";
  };
}
