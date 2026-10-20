#!/bin/bash
set -eu

# Only relevant inside WSL2 — no-op everywhere else (Linux desktop, macOS, etc.)
if ! grep -qi microsoft /proc/version 2>/dev/null; then
    exit 0
fi

# WSL2 + `systemd=true` (see /etc/wsl.conf) has a known race: WSL's init
# registers the WSLInterop binfmt_misc handler (so Linux can exec Windows .exe
# files via /init) before systemd-binfmt.service runs and clears it out, and
# nothing re-registers it. Without it, every Windows-binary launch from WSL
# (browsers, cmd.exe, xdg-open shims, etc.) fails with "exec format error".
#
# This installs a oneshot systemd unit that re-registers it after
# systemd-binfmt.service runs on every boot.

UNIT_PATH=/etc/systemd/system/wsl-interop-fix.service

sudo tee "$UNIT_PATH" > /dev/null <<'EOF'
[Unit]
Description=Re-register WSL interop binfmt_misc handler lost to systemd-binfmt race
After=systemd-binfmt.service
Requires=systemd-binfmt.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/sh -c '[ -e /proc/sys/fs/binfmt_misc/WSLInterop ] || echo ":WSLInterop:M::MZ::/init:PF" > /proc/sys/fs/binfmt_misc/register'

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now wsl-interop-fix.service
