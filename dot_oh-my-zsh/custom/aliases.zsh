# ── Navigation ────────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# oh-my-zsh's `take` already does mkdir -p + cd; expose as mkcd too
alias mkcd="take"

# ── eza (ls replacement) ──────────────────────────────────────────────────────
# eza plugin (loaded first) adds ldot, lS, lT, lD — these override its ls/ll/la
alias ls="eza --group-directories-first"
alias l="eza -lh --group-directories-first --git"
alias ll="eza -lah --group-directories-first --git"
alias la="eza -a --group-directories-first"
alias tree="eza --tree --group-directories-first"
alias treeic="eza --tree --icons=always --group-directories-first"

# ── bat (cat replacement) ─────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat="bat"
  alias catp="bat --plain"
fi

# ── fd (find replacement) ────────────────────────────────────────────────────
alias fda="fd --hidden"
alias fdg="fd --no-ignore"
alias fdall="fd --hidden --no-ignore"

# ── ripgrep ───────────────────────────────────────────────────────────────────
alias rgl="rg -l"
alias rga="rg --hidden --no-ignore"
alias rgc="rg --count"

# ── duf / dust (df/du replacements) ──────────────────────────────────────────
if command -v duf &>/dev/null; then
  alias df="duf"
fi
if command -v dust &>/dev/null; then
  alias du="dust"
fi

# ── Editors ───────────────────────────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# ── lazygit / lazydocker ──────────────────────────────────────────────────────
alias lg="lazygit"
if command -v lazydocker &>/dev/null; then
  alias ld="lazydocker"
fi

# ── Git (custom / git-plugin overrides) ───────────────────────────────────────
# The git plugin handles most aliases; these are unique or intentionally differ.
# Log — gl overrides plugin's gl=git pull
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
alias gla="git log --oneline --graph --decorate --all"
alias glp="git log -p --follow"
alias gll="git log --stat --decorate"

# Staging — gap overrides plugin's gap=git apply
alias gap="git add -p"

# Committing — differ from or conflict with git plugin equivalents
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcane="git commit --amend --no-edit"
alias gcob="git checkout -b"
alias gwip="git add --all && git commit -m 'wip'"
alias gunwip="git log -1 --format='%s' | grep -q 'wip' && git reset HEAD~1"

# Remote
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gup="git pull --rebase"
alias gfa="git fetch --all --prune"
alias gcl="git clone"
alias gcld="git clone --depth=1"

# Stash — gst overrides plugin's gst=git status
alias gst="git stash"

# Reset / misc — grst overrides plugin's grst=git restore --staged
alias grst="git restore"
alias grsth="git reset --hard"
alias gclean="git clean -fd"
alias gnuke="git reset --hard && git clean -fd"

# ── Docker / Self-Hosting ─────────────────────────────────────────────────────
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dpsa="docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dco="docker compose"
alias dcup="docker compose up -d"
alias dcdown="docker compose down"
alias dclogs="docker compose logs -f"
alias dcb="docker compose build"
alias dcr="docker compose restart"
alias dcp="docker compose pull"
alias dce="docker compose exec"
alias dprune="docker system prune -af"

# ── System / Misc ─────────────────────────────────────────────────────────────
alias reload="source ~/.zshrc"
alias path='echo $PATH | tr ":" "\n"'
alias ports="ss -tulanp"
alias myip="curl -s ifconfig.me"
alias myips="ip -br a"
alias usage="du -sh ./* | sort -h"
alias now="date '+%Y-%m-%d %H:%M:%S'"

# ── Alias Browser (Alt+A) ─────────────────────────────────────────────────────
function _fzf_alias_widget() {
  local selected
  selected=$(alias | sort | fzf \
    --height 70% --reverse --border \
    --preview 'echo {} | sed -E "s/^[^=]+=//; s/^\x27//; s/\x27$//"' \
    --preview-window=right:50%:wrap \
    --prompt="alias > " \
    --query="$LBUFFER" 2>/dev/null) || return
  LBUFFER="${selected%%=*}"
  zle reset-prompt
}
zle -N _fzf_alias_widget


# ── Skills.sh alias for agentic AI skills Browser ─────────────────────────────────────────────────────
alias skills="npx skills"
