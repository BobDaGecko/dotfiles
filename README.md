# BobDaGecko's Dotfiles

This repository acts as the "source of truth" for my personal development environment. 

## Philosophy & Architecture

The core philosophy of this project is to build a system that is **OS and environment agnostic** and **highly dynamic**. Whether deploying to a daily-driver Windows or Linux desktop, a WSL instance, or a minimal headless server, this setup allows for the rapid installation of preferred environments or the selective tracking of specific configuration files.

This flexibility is achieved by orchestrating three primary tools:

* **[Chezmoi](https://www.chezmoi.io/):** The core dotfile manager. It applies the configuration files, handles templating, and runs automation scripts.
* **[Mise](https://mise.jdx.dev/):** Used for the streamlined, dynamic management of programming languages, SDKs, and package managers (like `npm`, `pip`, and `cargo`). It replaces disparate tools like `nvm` or `pyenv` and centralizes environment configuration. 
* **[RBW / Bitwarden](https://github.com/doy/rbw):** A stateful, background-agent client for Bitwarden. `rbw` is strategically installed early in the bootstrap process. It manages a secure, timed vault session and provides a native SSH Agent. This allows `chezmoi` to seamlessly fetch secrets and authenticate with GitHub—ensuring automated setups succeed even if this repository is set to private.

---

## The Bootstrap Process

Setting up a fresh machine occurs in two automated stages:

1. **Stage 1 (Base Foundations):** A single script detects your OS, installs core system dependencies (Git, Curl, Unzip), provisions the toolchain (`mise` and `rbw`), and authenticates your vault and SSH keys. 
2. **Stage 2 (Chezmoi Orchestration):** After pulling the repository, `chezmoi` templates your config files to the system and executes `run_once_` scripts to finalize language runtimes.

---

## Quick Start (Linux / WSL)

On Debian, Ubuntu, Arch, or Fedora, use the universal bootstrap script. It will detect your package manager and prompt you for installation preferences.

```bash
# One-liner bootstrap
sudo apt update && sudo apt install -y curl || sudo pacman -Syu --noconfirm curl || sudo dnf install -y curl; bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobdagecko/dotfiles/main/bootstrap.sh)"
```

### Script Flags
You can automate the script behavior by passing flags. If no flags are passed, the script defaults to interactive prompts.

| Flag | Description |
| :--- | :--- |
| `--mise` / `--no-mise` | Explicitly enable or skip `mise` installation. |
| `--rbw` / `--no-rbw` | Explicitly enable or skip `rbw` installation. |
| `--no-prompt` | Run with all defaults (Full setup) without asking. |

**Example: Minimal Server Setup**
Installs only Git and Chezmoi, skipping the language managers and password vaults.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobdagecko/dotfiles/main/bootstrap.sh)" -s -- --no-mise --no-rbw
```

---

## Windows 11 Instructions

Windows operates outside the bash scripts. It uses a combination of the official Bitwarden Desktop App (for the SSH agent) and the `bw` CLI (for programmatic secret fetching). 

Open **PowerShell as Administrator** and follow these steps:

### 1. Install Toolchain via WinGet
```powershell
winget install --id Git.Git -e --source winget
winget install --id Bitwarden.Bitwarden -e --source winget
winget install --id Bitwarden.BitwardenCLI -e --source winget
winget install --id jdx.mise -e --source winget
winget install --id twpayne.chezmoi -e --source winget
```

### 2. Configure Windows OpenSSH
To enable the Bitwarden SSH Agent on Windows, the default Windows OpenSSH service must be disabled.
1. Use the Windows Search bar to navigate to **Services**.
2. Locate **OpenSSH Authentication Agent**.
3. Open the properties, set the **Startup type** to `Disabled`, select Apply, and click OK.

### 3. Configure Bitwarden Desktop App
1. Open the newly installed Bitwarden Desktop app and log in.
2. Navigate to **Settings** and enable **SSH agent**.
3. Adjust the *Ask for authorization when using SSH agent* setting if desired (options include *Always*, *Never*, or *Remember until vault is locked*).

### 4. Authenticate CLI & Pull Repository
Because SSH agent authentication is enabled, you will pull the repository over SSH.

```powershell
# Log in to the CLI wrapper (Unlock via desktop, or use standard login)
bw login
$env:BW_SESSION = (bw unlock --raw)

# Authenticate with GitHub via the Bitwarden SSH Agent
ssh -T git@github.com

# Initialize Chezmoi
chezmoi init --apply git@github.com:bobdagecko/dotfiles.git
```

---

## Post-Install Verification

Upon the completion of the first `chezmoi apply`, the following happens automatically:

1. **Runtimes:** A background script executes `mise install`, syncing your language versions (Node, Go, Python, Rust) according to the global `mise.toml`.
2. **Verification:** Run `chezmoi status` to ensure your local system state matches the repository expectations.
