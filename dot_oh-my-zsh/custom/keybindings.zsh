# Bind Up/Down arrows for history substring search
# This must run after the plugin is loaded, which OMZ handles by sourcing this file last.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind Ctrl+Space to accept zsh-autosuggestions
bindkey '^ ' autosuggest-accept
