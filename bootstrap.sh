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
        echo "Installing Rust via Mise (Global)..."
        mise use -g rust@latest
        eval "$(mise activate bash)"
    else
        echo "Installing Rust via standard rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        export PATH="$HOME/.cargo/bin:$PATH"
        source "$HOME/.cargo/env"
    fi
fi

# 3. Build & Install RBW
REPO_URL="https://github.com/bobdagecko/dotfiles.git"

if [ "$INSTALL_RBW" = true ]; then
    # Ensure build dependencies
    case $PKG_MGR in
        apt) sudo apt install -y build-essential libssl-dev pkg-config pinentry-tty ;;
        pacman) sudo pacman -S --noconfirm base-devel openssl pkg-config pinentry ;;
        dnf) sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y openssl-devel pkgconfig pinentry ;;
    esac

    echo "Compiling and installing RBW..."
    if command -v mise &> /dev/null; then
        mise x -- cargo install rbw
    else
        cargo install rbw
    fi
    
    export PATH="$HOME/.cargo/bin:$PATH"

    echo "Configuring RBW..."
    read -p "Enter Bitwarden email: " email
    rbw config set email "$email"
    rbw login

    # SSH Agent Integration
    echo "Enabling SSH Agent..."
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
    
    # Pre-add GitHub known hosts to prevent interactive prompt hang
    mkdir -p ~/.ssh
    ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
    
    echo "Authenticating with GitHub..."
    # ssh -T exits with 1 on success, which would kill the script due to set -e. The || true handles this gracefully.
    ssh -T git@github.com || true

    # Switch to SSH URL for cloning private repos
    REPO_URL="git@github.com:bobdagecko/dotfiles.git"
fi

# 4. Chezmoi
if ! command -v chezmoi &> /dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/bin
fi

echo "Initializing Chezmoi..."
$HOME/bin/chezmoi init --apply "$REPO_URL"
