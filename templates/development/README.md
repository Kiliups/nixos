# Development Home Manager configuration

A standalone Home Manager flake built on the `development` module of
[kiliups/nixos](https://github.com/kiliups/nixos): Zsh, Starship, tmux, Herdr,
LazyVim, VS Code, Zed, Git, the AI coding agents, and language toolchains.

## First-Time Setup

Install Nix before using the template.

On macOS, install [Determinate Nix](https://docs.determinate.systems/determinate-nix/):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

On Linux distributions other than NixOS, install the multi-user Nix daemon:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Open a new terminal, then enable the commands used by this template if they are
not already enabled:

```bash
mkdir -p ~/.config/nix
printf 'experimental-features = nix-command flakes\n' >> ~/.config/nix/nix.conf
```

Download the template into a new directory:

```bash
mkdir development
cd development
nix flake init -t github:kiliups/nixos#development
```

## Usage

Set `system`, `username`, and `home.stateVersion` in `flake.nix`, then apply it:

```bash
nix run home-manager -- switch --flake .#me
```

For macOS, set `darwinSystem` and apply the Darwin configuration. This
bootstraps `darwin-rebuild` on the first run:

```bash
nix run github:nix-darwin/nix-darwin -- switch --flake .#me
```

## Customizing

Every opinionated default is an option:

- `development.full.enable` turns on every editor, terminal tool, and built-in
  language at once, leaving the AI agents opt-in.
- `development.<tool>.enable` picks tools individually.
- `development.herdr.config`, `development.tmux.config`, and
  `development.lazyvim.config` each replace that tool's bundled configuration.
- `development.vscode.settings`, `development.vscode.extensions`,
  `development.zed.settings`, and `development.zed.extensions` customize the
  bundled editors. Disable an editor to configure it directly with Home Manager.
- `development.languages.<name>` enables a built-in language or defines a new
  one; each entry wires its packages, session variables, editor extensions and
  settings, and LazyVim extras into whichever editors are enabled. C and Nix
  are enabled by default.

Run `nix flake update nixos` to move to newer tooling.

Generate the module option reference with:

```bash
nix build .#development-options
```
