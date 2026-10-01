# dotfiles

macOS shell setup: zsh + oh-my-zsh (plugins only) + Starship prompt, Ghostty, git, ssh, Homebrew bundle.

## New machine

Interactive (prompts for git name / email / GPG key):

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kierzniak/dotfiles/master/install.sh)"
```

(`curl … | bash` also works; the script re-executes itself with stdin on the terminal.)

Non-interactive:

```sh
GIT_NAME="Your Name" GIT_EMAIL="you@example.com" GIT_SIGNINGKEY="" \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/kierzniak/dotfiles/master/install.sh)"
```

Notes:

- Fresh Mac without Xcode CLT: the script opens the install dialog and exits. Re-run once it finishes.
- Installs Homebrew, `Brewfile`, oh-my-zsh, nvm, rustup, then symlinks everything. Safe to re-run.
- `SKIP_BREW=1` skips Homebrew packages.
- Clones over HTTPS so no SSH key is needed. Switch later:
  `git -C ~/.dotfiles remote set-url origin git@github.com:kierzniak/dotfiles.git`
- Afterwards: `exec zsh`, then add private hosts to `~/.ssh/config.local`.

## Layout

| Path | Linked to | Notes |
|---|---|---|
| `*.symlink` | `~/.<name>` | zshrc, zprofile, gitconfig, gitignore, vimrc |
| `zshell/{env,config,aliases,functions}` | sourced by zshrc | PATH, prompt init, aliases |
| `oh-my-zsh/config` | sourced by zshrc | plugins only, theme off (Starship owns prompt) |
| `config/starship.toml` | `~/.config/starship.toml` | prompt |
| `config/ghostty` | `~/.config/ghostty/config` | terminal |
| `ssh/config` | `~/.ssh/config` | shared options only |
| `Brewfile` | — | `brew bundle --file ~/.dotfiles/Brewfile` |

## Never committed (machine-local)

| File | Purpose | Template |
|---|---|---|
| `~/.gitconfig.local` | name, email, signingkey | `gitconfig.local.example` |
| `~/.ssh/config.local` | private hosts, IPs | `ssh/config.local.example` |
| `~/.zshrc.local` | machine-specific PATH/aliases | `zshrc.local.example` |
