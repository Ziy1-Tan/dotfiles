# AGENTS.md

- Keep `home.stateVersion` unchanged in routine updates; change it only for an intentional Home Manager state migration.
- Keep `bootstrap.sh` safe to rerun: avoid duplicate Nix settings and always activate Home Manager so source changes take effect.
- Changes to installation, activation, or shell configuration flow require local and cross-OS validation: on macOS, test locally and in an Ubuntu container; on Ubuntu, test locally and on macOS. CI counts only when it runs on the required OS.
