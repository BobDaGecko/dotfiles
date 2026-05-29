# Default Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language Environment
export LANG=en_US.UTF-8

# Custom PATH additions
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Initialize rbw SSH agent (if installed)
if command -v rbw &> /dev/null; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
fi

# Initialize mise (if installed)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Initialize Zoxide (if installed)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
