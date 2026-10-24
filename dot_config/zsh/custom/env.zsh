# Language Environment
export LANG=en_US.UTF-8

# Default Editor
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# Initialize rbw SSH agent (if installed). Mirrors rbw's own socket dir:
# $XDG_RUNTIME_DIR/rbw, or $TMPDIR/rbw-$UID when that's unset (no systemd)
if command -v rbw &> /dev/null; then
  if [[ -n "$XDG_RUNTIME_DIR" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
  else
    export SSH_AUTH_SOCK="${TMPDIR:-/tmp}/rbw-$UID/ssh-agent-socket"
  fi
fi

# GitHub token for MCP servers and http requests (sourced from gh CLI credential store)
if command -v gh &> /dev/null; then
  export GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token 2>/dev/null)
fi

# Set up fzf key bindings and fuzzy completion
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi
