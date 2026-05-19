# Default Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language Environment
export LANG=en_US.UTF-8

# Custom PATH additions
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Initialize Zoxide (if installed)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi
