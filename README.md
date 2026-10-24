# BobDaGecko's Dotfiles

This repository acts as the "source of truth" for my personal development environment.

## Philosophy & Architecture

The core philosophy of this project is to build a system that is **OS and environment agnostic** and **highly dynamic**. Whether deploying to a daily-driver Windows or Linux desktop, a WSL instance, or a minimal headless server, this setup allows for the rapid installation of preferred environments or the selective tracking of specific configuration files.

This flexibility is achieved by orchestrating three primary tools:

* **[Chezmoi](https://www.chezmoi.io/):** The core dotfile manager. It applies the configuration files, handles templating, clones third-party shell plugins, and runs automation scripts.
* **[Mise](https://mise.jdx.dev/):** Used for the streamlined, dynamic management of programming languages, SDKs, and CLI tools. It replaces disparate tools like `nvm` or `pyenv` and centralizes environment configuration in `~/.config/mise/config.toml`.
* **[RBW / Bitwarden](https://github.com/doy/rbw):** A stateful, background-agent client for Bitwarden. `rbw-agent` holds a timed vault session **and serves the vault's SSH keys as a native SSH agent**, so `git@github.com` works on every Linux/WSL machine without key files on disk and without bridging to the Windows Bitwarden app.

---

## What's in here

| Source path | Becomes | Notes |
| :--- | :--- | :--- |
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | Asks once per machine: git name/email, Bitwarden email. Detects WSL (`is_wsl`). |
| `.chezmoiexternal.toml` | `~/.oh-my-zsh`, `~/.config/zsh/custom/{plugins,themes}/*` | oh-my-zsh, Powerlevel10k and the 6 third-party zsh plugins. Cloned on first apply, pulled weekly. |
| `.chezmoiremove` | — | Deletes the pre-Oct-2026 copies under `~/.oh-my-zsh/custom`. |
| `dot_zshrc`, `dot_p10k.zsh` | `~/.zshrc`, `~/.p10k.zsh` | `ZSH_CUSTOM=~/.config/zsh/custom`. |
| `dot_config/zsh/custom/*.zsh` | `~/.config/zsh/custom/` | `aliases.zsh`, `env.zsh` (rbw SSH agent, fzf, editor), `keybindings.zsh`. |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | Global runtimes and CLIs. |
| `dot_config/nvim/` | `~/.config/nvim/` | LazyVim. `markdown-preview.lua` is templated (WSL opens Windows Firefox). |
| `dot_config/git/` | `~/.config/git/{config,ignore}` | Identity + global ignore. |
| `create_empty_dot_gitconfig` | `~/.gitconfig` | Created empty, never overwritten. Catches machine-local `git config --global` writes (e.g. `gh auth setup-git`) so they don't land in the managed XDG file. |
| `dot_config/rbw/create_config.json.tmpl` | `~/.config/rbw/config.json` | Only created if missing. After that, rbw owns it (`rbw config set ...`). |
| `run_once_before_05-oh-my-zsh-git-check.sh` | — | Moves a non-git `~/.oh-my-zsh` aside so the external can clone it. |
| `run_onchange_before_10-install-packages.sh.tmpl` | — | apt/pacman/dnf base packages, then `chsh` to zsh. |
| `run_onchange_after_20-mise-install.sh.tmpl` | — | `mise install` whenever `config.toml` changes. |
| `run_onchange_after_30-nvim-lazy-restore.sh.tmpl` | — | `Lazy! restore` whenever `lazy-lock.json` changes. |
| `run_onchange_after_setup-wsl-interop.sh` | — | WSL only: systemd unit that re-registers the `WSLInterop` binfmt handler. |

---

## The Bootstrap Process

Setting up a fresh machine occurs in two automated stages:

1. **Stage 1 (Base Foundations, `bootstrap.sh`):** Detects the distro, installs Git/Curl/Unzip, provisions `mise`, builds `rbw` with Cargo, unlocks the vault (which starts the SSH agent), and checks GitHub SSH auth.
2. **Stage 2 (Chezmoi Orchestration):** `chezmoi init --apply` asks the per-machine questions, installs system packages, lays down the files, clones oh-my-zsh and the plugins, then runs `mise install` and pins the Neovim plugins.

---

## Quick Start (Linux / WSL)

On Debian, Ubuntu, Arch, or Fedora, use the universal bootstrap script. It will detect your package manager and prompt you for installation preferences.

```bash
# One-liner bootstrap
sudo apt update && sudo apt install -y curl || sudo pacman -Syu --noconfirm curl || sudo dnf install -y curl; bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobdagecko/dotfiles/main/bootstrap.sh)"
```

Then open a new terminal (zsh is now the login shell) and run `rbw unlock` once per session when SSH asks for a key.

### Script Flags
You can automate the script behavior by passing flags. If no flags are passed, the script defaults to interactive prompts.

| Flag | Description |
| :--- | :--- |
| `--mise` / `--no-mise` | Explicitly enable or skip `mise` installation. |
| `--rbw` / `--no-rbw` | Explicitly enable or skip `rbw` installation. |
| `--no-prompt` | Run with all defaults (Full setup) without asking. |

**Example: Minimal Server Setup**
Installs only Git and Chezmoi, skipping the language managers and password vaults. The repo is public, so it clones over HTTPS.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobdagecko/dotfiles/main/bootstrap.sh)" -s -- --no-mise --no-rbw
```

---

## Day-to-day

```bash
chezmoi update             # git pull + apply (what you run on the "other" machine)
chezmoi update --init      # same, but re-reads .chezmoi.toml.tmpl first (needed when it gained new questions)
chezmoi diff               # preview before applying
chezmoi edit --apply ~/.zshrc
chezmoi re-add             # pull edits made directly in $HOME back into the repo
chezmoi cd                 # drop into the repo to commit/push
```

Gotchas:

* `mise use -g <tool>` edits the live `~/.config/mise/config.toml`. Follow it with `chezmoi re-add ~/.config/mise/config.toml`.
* After `:Lazy update` in Neovim, `chezmoi re-add ~/.config/nvim/lazy-lock.json` so other machines pin the same versions.
* Adding a third-party zsh plugin means editing **both** `plugins=()` in `dot_zshrc` and `.chezmoiexternal.toml`.
* `rbw` must be unlocked (`rbw unlock`) before `git push`/`ssh` will find a key.
* Machine without rbw yet? Install it first (see `bootstrap.sh` step 3) or pull over HTTPS: `chezmoi git -- remote set-url origin https://github.com/bobdagecko/dotfiles.git`.

---

## Windows 11

Chezmoi is **not** applied on the Windows side yet (`.chezmoiignore` keeps zsh files out of `C:\Users` if it ever is). For Git on the Windows host itself, the Bitwarden Desktop app's SSH agent is used:

1. `winget install --id Bitwarden.Bitwarden -e --source winget`
2. **Services** → **OpenSSH Authentication Agent** → Startup type `Disabled` (the Bitwarden agent takes over the same pipe).
3. Bitwarden Desktop → **Settings** → enable **SSH agent**.

WSL does **not** use this agent. It runs its own `rbw-agent` (see above), so no npiperelay/socat bridge is needed.

---

## Post-Install Verification

```bash
chezmoi status             # should print nothing
chezmoi doctor             # chezmoi's own health check
rbw unlocked && ssh-add -l # vault unlocked, keys visible
ssh -T git@github.com      # "Hi BobDaGecko! ..."
mise ls --missing          # should print nothing
```
