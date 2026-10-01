#!/usr/bin/env bash
#
# Bootstrap a macOS machine with these dotfiles. Idempotent — safe to re-run.
#
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/kierzniak/dotfiles/master/install.sh)"
#
# Non-interactive: GIT_NAME="..." GIT_EMAIL="..." GIT_SIGNINGKEY="..." ./install.sh
# Skip Homebrew packages: SKIP_BREW=1 ./install.sh

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
REPO="https://github.com/kierzniak/dotfiles.git"
RAW="https://raw.githubusercontent.com/kierzniak/dotfiles/master/install.sh"

# When run as `curl | bash`, stdin IS the script: any child that reads stdin
# (brew, installers) eats the rest of it, and prompts can't work. Re-exec with
# a fresh copy and stdin attached to the terminal.
if [ ! -t 0 ] && [ -z "${DOTFILES_REEXEC:-}" ] && ( : </dev/tty ) 2>/dev/null; then
  tmp="$(mktemp)"
  curl -fsSL "$RAW" -o "$tmp"
  DOTFILES_REEXEC=1 exec bash "$tmp" "$@" </dev/tty
fi

# True only when a real terminal can be opened (not just when /dev/tty exists)
has_tty() { ( : </dev/tty ) 2>/dev/null; }

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# link SRC DST — symlink, backing up any real file already at DST
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.backup.$(date +%s)"
    warn "Backed up existing $dst"
  fi
  ln -sfn "$src" "$dst"
  log "Linked $dst -> $src"
}

# ask VAR "Prompt" [default] — read from tty if interactive, else keep env/default
ask() {
  local var="$1" prompt="$2" default="${3:-}" value
  if [ -n "${!var:-}" ]; then return; fi
  if has_tty; then
    read -rp "$prompt${default:+ [$default]}: " value </dev/tty
    printf -v "$var" '%s' "${value:-$default}"
  else
    printf -v "$var" '%s' "$default"
  fi
}

# ---------------------------------------------------------------- repository
if [ ! -d "$DOTFILES/.git" ]; then
  log "Cloning $REPO -> $DOTFILES"
  git clone "$REPO" "$DOTFILES"
else
  log "Updating $DOTFILES"
  git -C "$DOTFILES" pull --ff-only origin master || warn "pull failed, continuing with local copy"
fi

# ---------------------------------------------------------------- git identity (ask first, before long installs)
if [ ! -f "$HOME/.gitconfig.local" ]; then
  log "Git identity (stored in ~/.gitconfig.local, never committed)"
  ask GIT_NAME       "  Git user.name"
  ask GIT_EMAIL      "  Git user.email"
  ask GIT_SIGNINGKEY "  GPG signing key (blank to skip)"
  if [ -z "${GIT_NAME:-}" ] || [ -z "${GIT_EMAIL:-}" ]; then
    warn "No git identity given; create ~/.gitconfig.local from gitconfig.local.example"
  else
    {
      echo "[user]"
      echo "  name = $GIT_NAME"
      echo "  email = $GIT_EMAIL"
      [ -n "${GIT_SIGNINGKEY:-}" ] && echo "  signingkey = $GIT_SIGNINGKEY"
      if [ -n "${GIT_SIGNINGKEY:-}" ]; then echo "[commit]"; echo "  gpgsign = true"; fi
    } > "$HOME/.gitconfig.local"
    log "Wrote ~/.gitconfig.local"
  fi
fi

# ---------------------------------------------------------------- macOS deps
if [ "$(uname)" = "Darwin" ]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode Command Line Tools (follow the dialog, then re-run)"
    xcode-select --install
    exit 1
  fi

  if ! have brew; then
    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if [ -z "${SKIP_BREW:-}" ]; then
    log "Installing Homebrew bundle"
    brew bundle --file "$DOTFILES/Brewfile" --no-upgrade || warn "brew bundle had failures (see above)"
  fi
fi

# ---------------------------------------------------------------- shell tools
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing oh-my-zsh"
  ZSH="$HOME/.oh-my-zsh" RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" </dev/null \
    || warn "oh-my-zsh installer failed"
fi
[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] || warn "oh-my-zsh missing at ~/.oh-my-zsh — shell will skip it"

if [ ! -d "$HOME/.nvm" ]; then
  log "Installing nvm"
  NVM_DIR="$HOME/.nvm" PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh)" </dev/null \
    || warn "nvm installer failed"
fi

if ! have cargo && [ ! -d "$HOME/.cargo" ]; then
  log "Installing Rust (rustup)"
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path \
    || warn "rustup installer failed"
fi

# ---------------------------------------------------------------- symlinks
log "Symlinking dotfiles"
for location in "$DOTFILES"/*.symlink; do
  file="${location%.symlink}"
  file="${file##*/}"
  link "$location" "$HOME/.$file"
done

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
link "$DOTFILES/ssh/config"            "$HOME/.ssh/config"
link "$DOTFILES/config/ghostty"        "$HOME/.config/ghostty/config"
link "$DOTFILES/config/starship.toml"  "$HOME/.config/starship.toml"

# ---------------------------------------------------------------- local (uncommitted) files
if [ ! -f "$HOME/.ssh/config.local" ]; then
  cp "$DOTFILES/ssh/config.local.example" "$HOME/.ssh/config.local"
  log "Created ~/.ssh/config.local — add private hosts there"
fi
chmod 600 "$HOME/.ssh/config.local"

if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zshrc.local.example" "$HOME/.zshrc.local"
  log "Created ~/.zshrc.local — machine-specific shell config goes there"
fi

# ---------------------------------------------------------------- done
if [ "$SHELL" != "$(command -v zsh)" ] && have zsh; then
  warn "Default shell is $SHELL. Run: chsh -s $(command -v zsh)"
fi
log "Done. Open a new terminal (or: exec zsh)."
