#!/usr/bin/env bash
set -e

# Defaults
INSTALL_MISE=null
INSTALL_RBW=null
NO_PROMPT=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --mise) INSTALL_MISE=true ;;
        --no-mise) INSTALL_MISE=false ;;
        --rbw) INSTALL_RBW=true ;;
        --no-rbw) INSTALL_RBW=false ;;
        --no-prompt) NO_PROMPT=true ;;
        *) echo "Unknown arg: $1"; exit 1 ;;
    esac
    shift
done

# Prompt resolution
if [ "$INSTALL_MISE" == "null" ]; then
    [ "$NO_PROMPT" = true ] && INSTALL_MISE=true || { read -p "Install Mise? [Y/n] " input; [[ ! "$input" =~ ^[Nn] ]] && INSTALL_MISE=true || INSTALL_MISE=false; }
fi
if [ "$INSTALL_RBW" == "null" ]; then
    [ "$NO_PROMPT" = true ] && INSTALL_RBW=true || { read -p "Install RBW? [Y/n] " input; [[ ! "$input" =~ ^[Nn] ]] && INSTALL_RBW=true || INSTALL_RBW=false; }
fi

# Detect OS
. /etc/os-release
case $ID in
    debian|ubuntu|pop|mint) PKG_MGR="apt" ;;
    arch|manjaro|cachyos) PKG_MGR="pacman" ;;
    fedora|rhel|centos|almalinux|rocky) PKG_MGR="dnf" ;;
    *) echo "Unsupported OS"; exit 1 ;;
esac

# 1. Base Installation
case $PKG_MGR in
    apt) sudo apt update && sudo apt install -y git curl unzip ;;
    pacman) sudo pacman -Syu --noconfirm git curl unzip ;;
    dnf) sudo dnf install -y git curl unzip ;;
esac

# 2. Toolchain Bootstrap (Install Mise/Rust/Cargo)
if [ "$INSTALL_MISE" = true ]; then
    if ! command -v mise &> /dev/null; then
        echo "Installing Mise..."
        curl https://mise.run | sh
        eval "$($HOME/.local/bin/mise activate bash)"
    fi
fi

if [ "$INSTALL_RBW" = true ] && ! command -v cargo &> /dev/null; then
    if [ "$INSTALL_MISE" = true ]; then
        # `mise install`, not `mise use -g`: the latter edits
        # ~/.config/mise/config.toml before chezmoi lays down the managed
        # copy, which makes the first `chezmoi apply` stop on a conflict.
        echo "Installing Rust via Mise..."
        mise install rust@latest
    else
        echo "Installing Rust via standard rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        export PATH="$HOME/.cargo/bin:$PATH"
        source "$HOME/.cargo/env"
    fi
fi

# 3. Build & Install RBW
REPO_URL="https://github.com/bobdagecko/dotfiles.git"
SSH_OK=false

if [ "$INSTALL_RBW" = true ]; then
    # Ensure build dependencies
    case $PKG_MGR in
        apt) sudo apt install -y build-essential libssl-dev pkg-config pinentry-tty ;;
        pacman) sudo pacman -S --noconfirm base-devel openssl pkg-config pinentry ;;
        dnf) sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y openssl-devel pkgconfig pinentry ;;
    esac

    echo "Compiling and installing RBW..."
    if command -v mise &> /dev/null; then
        mise x rust@latest -- cargo install --locked rbw
    else
        cargo install --locked rbw
    fi
    
    export PATH="$HOME/.cargo/bin:$PATH"

    echo "Configuring RBW..."
    read -p "Enter Bitwarden email: " BW_EMAIL
    rbw config set email "$BW_EMAIL"
    rbw config set pinentry pinentry
    # unlock logs in first if needed, then starts rbw-agent (which also
    # serves the vault's SSH keys)
    rbw unlock

    # SSH Agent Integration
    echo "Enabling SSH Agent..."
    if [ -n "${XDG_RUNTIME_DIR:-}" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
    else
        export SSH_AUTH_SOCK="${TMPDIR:-/tmp}/rbw-$UID/ssh-agent-socket"
    fi
    
    # Pre-add GitHub known hosts to prevent interactive prompt hang
    mkdir -p ~/.ssh && chmod 700 ~/.ssh
    ssh-keygen -F github.com > /dev/null 2>&1 || ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
    
    echo "Authenticating with GitHub..."
    # ssh -T exits 1 even on success, so check its output instead
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        SSH_OK=true
    else
        echo "GitHub SSH auth failed; cloning over HTTPS (switch later with: chezmoi git -- remote set-url origin git@github.com:bobdagecko/dotfiles.git)"
    fi
fi

# 4. Chezmoi
if ! command -v chezmoi &> /dev/null && [ ! -x "$HOME/bin/chezmoi" ]; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/bin"
fi
CHEZMOI="$(command -v chezmoi || echo "$HOME/bin/chezmoi")"

# Pre-answer the rbw prompt in .chezmoi.toml.tmpl if we already asked for it
INIT_ARGS=()
[ -n "${BW_EMAIL:-}" ] && INIT_ARGS+=(--promptString "Bitwarden email (for rbw)=$BW_EMAIL")

echo "Initializing Chezmoi..."
"$CHEZMOI" init --apply "${INIT_ARGS[@]}" "$REPO_URL"

# Public repo clones fine over HTTPS; pushing needs the SSH remote
if [ "$SSH_OK" = true ]; then
    "$CHEZMOI" git -- remote set-url origin git@github.com:bobdagecko/dotfiles.git
fi
