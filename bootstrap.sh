#!/usr/bin/env bash
set -euo pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
NIX_PROFILE=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if [[ -r "$NIX_PROFILE" ]]; then
    . "$NIX_PROFILE"
fi

if command -v nix >/dev/null 2>&1; then
    echo "nix is already installed: $(nix --version)"
else
    command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
    curl --fail --location --proto '=https' --tlsv1.2 \
        "${NIX_INSTALL_URL:-https://nixos.org/nix/install}" | sh -s -- --daemon
    if [[ -r "$NIX_PROFILE" ]]; then
        . "$NIX_PROFILE"
    fi
fi

command -v nix >/dev/null 2>&1 || {
    echo "Nix was installed but is not on PATH; open a new shell and retry." >&2
    exit 1
}

sudo mkdir -p /etc/nix
nix_conf_changed=0
if ! sudo grep -Fqx 'experimental-features = nix-command flakes' /etc/nix/nix.conf 2>/dev/null; then
    printf '%s\n' 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf >/dev/null
    nix_conf_changed=1
fi
if ! sudo grep -Fqx 'substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/' /etc/nix/nix.conf 2>/dev/null; then
    printf '%s\n' 'substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/' | sudo tee -a /etc/nix/nix.conf >/dev/null
    nix_conf_changed=1
fi

if (( nix_conf_changed )); then
    if command -v launchctl >/dev/null 2>&1; then
        sudo launchctl kickstart -k system/org.nixos.nix-daemon 2>/dev/null || true
    elif command -v systemctl >/dev/null 2>&1; then
        sudo systemctl restart nix-daemon.service 2>/dev/null || true
    fi
fi

export NIX_CONFIG='substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/'

echo "Nix and binary caches are configured. Activating Home Manager..."
exec nix --extra-experimental-features 'nix-command flakes' run --impure \
    "${ROOT}#home-manager" -- switch --impure --flake "${ROOT}#default" "$@"
