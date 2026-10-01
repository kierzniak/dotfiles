# dotfiles

macOS shell setup: zsh + oh-my-zsh (plugins only) + Starship prompt, Ghostty, git, ssh, Homebrew bundle.

## New machine

```sh
curl -fsSL https://raw.githubusercontent.com/kierzniak/dotfiles/master/install.sh | bash
```

Prompts for git name / email / GPG key and writes them to `~/.gitconfig.local`.
Non-interactive: `GIT_NAME=... GIT_EMAIL=... GIT_SIGNINGKEY=... ./install.sh`.

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
