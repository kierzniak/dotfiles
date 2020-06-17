#
# Show simple green arrows "<<<"
#

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_ARROWS_SHOW="${SPACESHIP_ARROWS_SHOW=true}"
SPACESHIP_ARROWS_PREFIX="${SPACESHIP_ARROWS_PREFIX=""}"
SPACESHIP_ARROWS_SUFFIX="${SPACESHIP_ARROWS_SUFFIX=" "}"
SPACESHIP_ARROWS_SYMBOL="${SPACESHIP_ARROWS_SYMBOL="<<<"}"
SPACESHIP_ARROWS_COLOR="${SPACESHIP_ARROWS_COLOR="green"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show arrows status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_arrows() {

  # If SPACESHIP_ARROWS_SHOW is false, don't show arrows section
  [[ $SPACESHIP_ARROWS_SHOW == false ]] && return

  # Display arrows section
  spaceship::section \
    "$SPACESHIP_ARROWS_COLOR" \
    "$SPACESHIP_ARROWS_PREFIX" \
    "$SPACESHIP_ARROWS_SYMBOL" \
    "$SPACESHIP_ARROWS_SUFFIX"
}