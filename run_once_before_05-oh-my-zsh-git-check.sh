#!/bin/bash
# The .oh-my-zsh external is a git-repo external: chezmoi `git pull`s it, and
# that aborts the whole apply if ~/.oh-my-zsh exists but isn't a git checkout
# (e.g. a dir chezmoi itself created back when it managed ~/.oh-my-zsh/custom).
# Move such a dir aside so the external can clone fresh.
set -eu

OMZ="$HOME/.oh-my-zsh"
if [ -d "$OMZ" ] && ! git -C "$OMZ" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    BACKUP="$OMZ.pre-chezmoi-$(date +%Y%m%d%H%M%S)"
    echo "oh-my-zsh: $OMZ is not a git checkout, moving it to $BACKUP"
    mv "$OMZ" "$BACKUP"
fi
