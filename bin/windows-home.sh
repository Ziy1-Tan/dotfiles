#!/bin/bash
set -euo pipefail
PS=/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
[ -x "$PS" ] || PS=powershell.exe
win_home=$("$PS" -NoProfile -Command '[Console]::Out.Write($env:USERPROFILE)')
[ -n "$win_home" ] || { echo "cannot determine Windows home" >&2; exit 1; }
wslpath -u "$win_home"
