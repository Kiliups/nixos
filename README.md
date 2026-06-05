# NixOS Configuration

Personal Nix flake for Linux and macOS machines. It manages NixOS, nix-darwin,
Home Manager, development tooling, shell configuration, applications, and system
theming from one repository.

## Hosts

| Host | Platform | Purpose | User |
| --- | --- | --- | --- |
| `laptop` | NixOS, `x86_64-linux` | Laptop | `user` |
| `workstation` | NixOS, `x86_64-linux` | Workstation | `user` |
| `macbook` | nix-darwin, `aarch64-darwin` | macOS machine | `user` |

## Quickstart

Clone the repository to the location used by automatic upgrades:

```bash
git clone <repo-url> ~/.config/nixos
cd ~/.config/nixos
```

Create ignored private host data from the example and adjust it. Host attr names
are also the flake output names and machine hostnames.

```bash
cp hosts/private.example.nix hosts/private.nix
```

Enable flakes on a fresh NixOS install if they are not enabled yet:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Apply a NixOS host:

```bash
sudo nixos-rebuild switch --flake .#laptop --impure
sudo nixos-rebuild switch --flake .#workstation --impure
```

Apply the macOS host:

```bash
sudo -H nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#macbook --impure
```

## Updating

Update flake inputs:

```bash
nix flake update
```

Rebuild the current Linux host:

```bash
sudo nixos-rebuild switch --flake .#$(hostname) --impure
```

Automatic upgrades are enabled for NixOS hosts and use `~/.config/nixos` as the
flake path.

## Repository Layout

| Path | Description |
| --- | --- |
| `flake.nix` | Flake inputs, host definitions, and templates |
| `hosts/common.nix` | Shared NixOS system settings |
| `hosts/laptop` | Laptop-specific NixOS and Home Manager config |
| `hosts/workstation` | Workstation-specific NixOS config |
| `hosts/darwin` | nix-darwin and macOS Home Manager config |
| `modules/development` | Shell, editors, agents, tmux, Starship, and languages |
| `modules/linux` | Linux desktop, terminal, Plasma, and tiling modules |
| `modules/darwin` | macOS-specific modules |
| `modules/apps` | Desktop application modules |
| `config` | Static config files, themes, wallpapers, and Neovim config |
| `templates` | Reusable development shell templates |

## Features

- Flake-based NixOS and nix-darwin systems.
- Home Manager for user packages and dotfiles.
- Stylix with Catppuccin Macchiato theming.
- KDE Plasma 6 with declarative shortcuts on Linux.
- Niri, Waybar, and Fuzzel modules for tiling workflows.
- Zsh, tmux, Starship, LazyVim, VS Code, and AI coding agents.
- Language modules for Angular, Astro, Go, Java, PHP, Python, Rust, Svelte,
  TypeScript, Typst, and Vue.
- Python development shell template via `nix flake init -t .#python`.

## Manual Steps

- **VS Code**: Install the Catppuccin theme extension manually if Stylix does not
  apply the desired theme.
- **KDE shortcuts**: Some declarative shortcuts may conflict with existing Plasma
  defaults and need to be overwritten manually.
- **eduroam**: Scripts live in `config/eduroam`. Download the `.p12` certificate
  from <https://www.easyroam.de/home>, extract it with the helper script, and fix
  read permissions if needed.
- **Terminal word jumps**: Verify the keybindings manually after applying the
  terminal configuration.
