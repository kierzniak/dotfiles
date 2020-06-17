#
# Show advanced arrows prompt ">>>"
#

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_ARROWS_PROMPT_SHOW="${SPACESHIP_ARROWS_PROMPT_SHOW=true}"
SPACESHIP_ARROWS_PROMPT_PREFIX="${SPACESHIP_ARROWS_PROMPT_PREFIX=""}"
SPACESHIP_ARROWS_PROMPT_SUFFIX="${SPACESHIP_ARROWS_PROMPT_SUFFIX=" "}"
SPACESHIP_ARROWS_PROMPT_SYMBOL="${SPACESHIP_ARROWS_PROMPT_SYMBOL=">>>"}"
SPACESHIP_ARROWS_PROMPT_NORMAL_COLOR="${SPACESHIP_ARROWS_PROMPT_NORMAL_COLOR="blue"}"
SPACESHIP_ARROWS_PROMPT_SSH_COLOR="${SPACESHIP_ARROWS_PROMPT_SSH_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show arrows prompt status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_arrows_prompt() {

  # If SPACESHIP_ARROWS_PROMPT_SHOW is false, don't show arrows prompt section
  [[ $SPACESHIP_ARROWS_PROMPT_SHOW == false ]] && return

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    SPACESHIP_ARROWS_PROMPT_COLOR="$SPACESHIP_ARROWS_PROMPT_SSH_COLOR"
  else
    SPACESHIP_ARROWS_PROMPT_COLOR="$SPACESHIP_ARROWS_PROMPT_NORMAL_COLOR"
  fi

  # Display arrows prompt section
  spaceship::section \
    "$SPACESHIP_ARROWS_PROMPT_COLOR" \
    "$SPACESHIP_ARROWS_PROMPT_PREFIX" \
    "$SPACESHIP_ARROWS_PROMPT_SYMBOL" \
    "$SPACESHIP_ARROWS_PROMPT_SUFFIX"
}