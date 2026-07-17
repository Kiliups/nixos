# NixOS Configuration

<div align="center">
<a href="https://nixos.org/">
  <img src="https://img.shields.io/static/v1?label=NixOS&message=unstable&style=for-the-badge&logo=nixos&color=89B4FA&logoColor=D9E0EE&labelColor=302D41" alt="NixOS unstable">
</a>
<a href="https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-flake">
  <img src="https://img.shields.io/static/v1?label=Nix%20Flakes&message=enabled&style=for-the-badge&logo=nixos&color=CBA6F7&logoColor=D9E0EE&labelColor=302D41" alt="Nix flakes enabled">
</a>
<a href="https://nix-community.github.io/home-manager/">
  <img src="https://img.shields.io/static/v1?label=Home%20Manager&message=managed&style=for-the-badge&logo=nixos&color=A6E3A1&logoColor=D9E0EE&labelColor=302D41" alt="Home Manager managed">
</a>
<a href="https://github.com/nix-community/stylix">
  <img src="https://img.shields.io/static/v1?label=Stylix&message=catppuccin&style=for-the-badge&logo=nixos&color=F5C2E7&logoColor=D9E0EE&labelColor=302D41" alt="Stylix Catppuccin">
</a>
</div>

Personal Nix flake for Linux and macOS machines. It manages NixOS,
nix-darwin, Home Manager, development tooling, applications, and theming from
one repository.

It features:

- Flake-based NixOS and nix-darwin systems.
- Home Manager user environments for Linux and macOS.
- Stylix with Catppuccin Macchiato theming and a matching GRUB theme.
- KDE Plasma 6 applications and sessions, plus Niri and DankMaterialShell for
  a cohesive tiling desktop.
- Zsh, tmux, Starship, Neovim, VS Code, Git, and AI coding agent tooling.
- Language modules for Angular, Astro, Go, Java, PHP, Python, Rust, Svelte,
  TypeScript, Typst, and Vue.
- A public/private split: reusable config is tracked here, while real host data
  lives in an ignored `private/` flake.

## Getting Started

Clone the repository to the path used by automatic upgrades:

```bash
git clone <repo-url> ~/.config/nixos
cd ~/.config/nixos
```

Create local private host data from the safe example:

```bash
cp -r private.example private
```

On NixOS, replace the example hardware config:

```bash
nixos-generate-config --show-hardware-config > private/laptop/hardware-configuration.nix
```

Enable flakes persistently on a fresh NixOS install if needed:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Or pass the experimental features inline for one-off first-run commands.

Apply a NixOS host for the first time:

```bash
sudo nixos-rebuild --option experimental-features "nix-command flakes" switch --flake path:$PWD#<host> --override-input nixos-private path:$PWD/private
```

On macOS, install [Determinate Nix](https://docs.determinate.systems/determinate-nix/)
first. This repo leaves Nix itself to Determinate Systems; the Darwin config sets
`nix.enable = false` so nix-darwin does not rewrite `/etc/nix/nix.conf`.

Apply the macOS host for the first time:

```bash
nix run nix-darwin -- switch --flake .#<host> --override-input nixos-private path:$PWD/private
```

## Private Host Data

The top-level flake defaults to `private.example/` so the public repository can
evaluate without personal data. Real machines override the `nixos-private` input
with the ignored `private/` flake.

Host attribute names in `private/flake.nix` are also the flake output names and
machine hostnames.

## Updating

Update inputs:

```bash
nix flake update
```

Or use the shell helper from `terminal.nix`:

```bash
nfu
```

Rebuild the current Linux host:

```bash
sudo nixos-rebuild switch --flake path:$PWD#$(hostname) --override-input nixos-private path:$PWD/private
```

Or use the Linux shell helper from `modules/linux/home/terminal.nix`:

```bash
nrs
```

Rebuild the current macOS host:

```bash
sudo darwin-rebuild switch --flake .#$(hostname -s) --override-input nixos-private path:$PWD/private
```

Or use the macOS shell helper from `modules/darwin/terminal.nix`:

```bash
drs
```

Update inputs and rebuild in one command:

```bash
nrsu # Linux
drsu # macOS
```

NixOS hosts also enable daily automatic upgrades from the pinned lock file in
`~/.config/nixos`. Input updates remain an explicit `nfu` operation.

## Theming

System theming is handled by Stylix with
`catppuccin-macchiato.yaml` from `base16-schemes`. The wallpaper is
`config/wallpaper.png`, and GRUB uses the bundled Catppuccin Macchiato theme in
`config/catppuccin-macchiato-grub-theme`.

## Repository Layout

| Path                   | Description                                                |
| ---------------------- | ---------------------------------------------------------- |
| `flake.nix`            | Inputs, host builders, exported modules, and templates     |
| `private.example/`     | Safe template for ignored local host data                  |
| `hosts/`               | Shared, Linux, laptop, workstation, and macOS host config  |
| `modules/development/` | Shell, editors, tmux, Starship, Git, agents, and languages |
| `modules/linux/desktop/` | System-level NixOS desktop modules                       |
| `modules/linux/home/`  | Home Manager desktop modules                               |
| `modules/linux/`       | Shared Linux user and terminal modules                     |
| `modules/darwin/`      | macOS-specific modules                                     |
| `modules/apps/`        | Desktop application modules                                |
| `config/`              | Static config files, themes, wallpapers, and Neovim config |
| `templates/`           | Development shell templates                                |

## Manual Notes

- VS Code may need the Catppuccin theme extension installed manually.
- Some KDE shortcuts may need to overwrite existing Plasma defaults after the
  first switch.
- **eduroam**: Scripts live in `config/eduroam`. Download the `.p12` certificate
  from <https://www.easyroam.de/home>, extract it with the helper script, and fix
  read permissions if needed.
- The Python shell template is available with `nix flake init -t .#python`.
