# MacBook Migration Guide

## Goal

Port the reusable parts of this NixOS configuration to a MacBook without trying to carry over Linux- and NixOS-specific system configuration.

The recommended target is a `nix-darwin + home-manager` setup on macOS.

## Recommended Approach

1. Keep all NixOS-only machine configuration separate.
2. Move cross-platform user configuration into shared Home Manager modules.
3. Add a separate `darwinConfigurations.<macbook>` entry to the flake.
4. Import only portable modules on macOS.
5. Add Darwin-specific replacements for Linux desktop and app integration where needed.

## What Is Already Portable

These are the best candidates to reuse with little or no restructuring:

- `modules/dev/starship.nix`
- `modules/dev/lazy.nix`
- most of `modules/dev/cli.nix`
- parts of `modules/dev/tools.nix`
- parts of `modules/dev/vscode.nix`

These are mostly shell, editor, tmux, and developer-tool concerns and already fit Home Manager well.

## What Is NixOS-Only

These should not be ported directly to the MacBook:

- `hosts/common.nix`
- `hosts/laptop/configuration.nix`
- `hosts/workstation/configuration.nix`

Reasons:

- `boot.*`
- `networking.networkmanager.*`
- `services.*`
- `hardware.*`
- `users.users.*`
- Linux audio, printing, bluetooth, KDE, and Docker daemon setup

These are NixOS system options, not macOS user configuration.

## What Is Linux Desktop-Specific

These should stay Linux-only or get macOS equivalents:

- `modules/plasma.nix`
- `modules/hypr/*`
- `xdg.mimeApps` in `modules/programs.nix`
- the KDE service menu block in `modules/dev/vscode.nix`

These depend on KDE, Hyprland, XDG desktop integration, or Linux desktop files.

## Likely Problem Areas On macOS

These modules need review before reuse:

- `modules/programs.nix`
  - packages like `teams-for-linux`, `zapzap`, and possibly `eduvpn-client` are likely Linux-only
- `modules/dev/tools.nix`
  - `docker`, `docker-compose`, `wireguard-tools`, `gdb`, and `dbeaver-bin` may differ or be unavailable on Darwin
- `modules/dev/vscode.nix`
  - writes settings to `~/.config/Code/User/settings.json`, while macOS VS Code typically uses `~/Library/Application Support/Code/User/settings.json`
- `config/tmux/tmux.conf`
  - currently hardcodes `/run/current-system/sw/bin/zsh`, which is not portable to macOS

## Suggested Repository Structure

A clean target layout is:

1. `modules/shared/*`
   Cross-platform Home Manager modules:
   - shell
   - git
   - tmux
   - neovim
   - starship
   - shared CLI tools
2. `modules/linux/*`
   Linux-only Home Manager modules:
   - Plasma
   - Hyprland
   - XDG mime apps
   - KDE service menus
3. `hosts/<host>/configuration.nix`
   NixOS-only
4. `hosts/<host>/home.nix`
   Per-host Home Manager imports
5. `hosts/macbook/home.nix`
   Darwin Home Manager imports
6. `hosts/macbook/darwin-configuration.nix`
   nix-darwin system config

## Flake Changes

Add inputs for macOS support:

- `nix-darwin`
- keep `home-manager`
- optionally `nix-homebrew` if Homebrew should be managed declaratively

Then add:

- `darwinConfigurations.<macbook> = nix-darwin.lib.darwinSystem { ... }`

and wire Home Manager into that Darwin config.

## What To Port First

Start with the highest-value, lowest-friction modules:

1. `modules/dev/starship.nix`
2. `modules/dev/lazy.nix`
3. `modules/dev/cli.nix`
4. `modules/dev/vscode.nix` after fixing the macOS settings path
5. selected packages from `modules/dev/tools.nix`

Leave these for later or split immediately:

1. `modules/programs.nix`
2. `modules/plasma.nix`
3. `modules/hypr/*`
4. anything in `hosts/common.nix`

## Packaging Strategy For macOS

Use three buckets for software on the MacBook:

1. Nix-managed and cross-platform
   - `git`, `zsh`, `tmux`, `ripgrep`, `fd`, `starship`, `neovim`
2. Nix-managed but Darwin-specific verification needed
   - `ghostty`, `vscode`, `obsidian`, `spotify`, `bitwarden-desktop`
3. Better via Homebrew, App Store, or manual install
   - GUI apps not well-supported in nixpkgs on Darwin
   - Linux-only apps such as `teams-for-linux`

## Specific Refactors To Plan

1. Split `modules/dev/cli.nix`
   - keep shell, git, fzf, zoxide, tmux helpers, and shared CLI tools in a cross-platform module
   - move Linux-specific terminal integration out if needed
2. Split `modules/dev/vscode.nix`
   - keep shared VS Code settings and extensions
   - isolate the Linux-only `kio/servicemenus` block
   - make the VS Code settings path platform-specific
3. Split `modules/programs.nix`
   - common apps
   - Linux-only apps
   - Darwin-only replacements where needed
4. Replace the hardcoded shell path in `config/tmux/tmux.conf`
   - the current `/run/current-system/sw/bin/zsh` path is platform-specific

## Recommended End State

- NixOS desktop hosts import:
  - shared modules
  - Linux desktop modules
  - NixOS system config
- MacBook host imports:
  - shared modules
  - Darwin-specific modules
  - no Linux desktop modules
  - no NixOS system modules

## Migration Order

1. Add `nix-darwin` to the flake.
2. Create `hosts/macbook/home.nix`.
3. Create `hosts/macbook/darwin-configuration.nix`.
4. Extract shared Home Manager modules.
5. Import only shared modules on macOS.
6. Add Darwin-safe package selections.
7. Add macOS-specific app and config replacements.
8. Build and iterate on missing packages and options.

## Recommendation

If the goal is to preserve the shell, dev, editor, and tmux experience on the MacBook, use `nix-darwin + Home Manager` and port only the shared development modules first.

Do not try to port the Linux desktop modules directly.

## Important Choice

There are two viable approaches:

1. `nix-darwin + Home Manager` for a more fully managed MacBook
2. Home Manager only on macOS for user-level tooling

The recommended option is `nix-darwin + Home Manager`.
