# Display time
SPACESHIP_TIME_SHOW=true

# Display username always
SPACESHIP_USER_SHOW=always

# Do not truncate path in repos
SPACESHIP_DIR_TRUNC_REPO=false

# Add custom vi-mode?
# spaceship add --before char vi_mode

SPACESHIP_PROMPT_ORDER=(
  user
  host
  dir
  git
  python
  rust
  haskell
  venv
  zig
  nix_shell
  )

SPACESHIP_RPROMPT_ORDER=(
  async
  exec_time
  battery
  jobs
  exit_code
  )
