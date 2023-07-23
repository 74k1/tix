function nas() {
  local source="${1:-nixpkgs}"
  local tmpfile=$(nix run nixpkgs#mktemp)
  nix search --json $source > $tmpfile

  cat $tmpfile | \
  nix run nixpkgs#jq -- -r 'to_entries | .[] | .key | split(".") | .[2:] | join(".")' | \
  nix run nixpkgs#skim -- --ansi --multi --preview \
  "cat $tmpfile | nix run nixpkgs#jq -- -r \"to_entries | .[] | select(.key | test(\\\".\$source\\\\\\\\.$\\\")) | \\\"Package: \(.key)\\nName: \(.value.pname)\\nVersion: \(.value.version)\\nDescription: \(.value.description)\\\"\""  
  
  rm -f $tmpfile
}

# eva reference :^)
function youcannotrebuild() {
  sudo --validate \
    && sudo nixos-rebuild --flake ~/tix#SEELE "${@:-switch}" \
    |& nix run nixpkgs#nix-output-monitor
}

# function nas() {
#   local source="${1:-nixpkgs}"
#   local search_results=$(nix search --json $source)
# 
#   echo "$search_results" | \
#   nix run nixpkgs#jq -- -r 'to_entries | .[] | .key | split(".") | .[2:] | join(".")' | \
#   nix run nixpkgs#skim -- --ansi --multi --preview \
#   "echo '$search_results' | nix run nixpkgs#jq -- -r \"to_entries | .[] | select(.key == \\\"\${1}.$source\\\") | \\\"Package: \(.key)\\nName: \(.value.pname)\\nVersion: \(.value.version)\\nDescription: \(.value.description)\\\"\""  
# }

# alias pas='echo $(brew casks) $(brew formulae) | tr " " "\n" | fzf --multi --preview '\''brew info {1}'\'' | xargs -ro brew install'

# make tmp file, and store keys there
# function nix_search() {
#     local source="${1:-nixpkgs}"
#     local tempfile=$(nix run nixpkgs#mktemp)
#     nix search --json $source > $tempfile
# 
#     local platform=$(nix run nixpkgs#jq -- -r 'to_entries[0].key | split(".") | .[:-2] | join(".")' $tempfile)
#   
#     cat $tempfile | nix run nixpkgs#jq -- -r 'to_entries | .[] | .key | split(".") | .[2:] | join(".")' | nix run nixpkgs#skim -- --ansi --multi --preview \
#     "nix run nixpks#jq -- -r \"to_entries | .[] | select(.key == \\\"$platform.\${}\\\") | \\\"Package: \(.key)\\nName: \(.value.pname)\\nVersion: \(.value.version)\\nDescription: \(.value.description)\\\"\" $tempfile"
#     
#     rm $tempfile
# }

