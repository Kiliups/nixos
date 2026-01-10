# Agent Guidelines for NixOS Configuration

This document provides guidelines for AI coding agents working in this NixOS configuration repository.

## Project Overview

This is a **personal NixOS configuration** using flakes, home-manager, and modular organization. It manages two hosts:
- **rivendell** (laptop): Framework 13 7040 AMD
- **minas-tirith** (workstation): Gaming/desktop machine

Key technologies: NixOS flakes, Home Manager, Stylix theming, KDE Plasma 6

## Build/Test/Lint Commands

### Primary Commands

```bash
# Rebuild system with current hostname (use this most often)
nrs

# Update flake inputs
nfu

# Update and rebuild in one command
nrsu

# Manual rebuild with specific hostname
sudo nixos-rebuild switch --flake .#rivendell --impure
sudo nixos-rebuild switch --flake .#minas-tirith --impure

# Check flake syntax
nix flake check

# Format Nix files
nixfmt <file>

# Build without activating (for testing)
nixos-rebuild build --flake .#$(hostname)

# Open config in VSCode
nx
```

### Testing Configuration Changes

**IMPORTANT:** NixOS has no traditional test suite. Testing is done through:

1. **Build validation:** `nixos-rebuild build --flake .#<hostname>`
2. **Dry run:** `nixos-rebuild dry-run --flake .#<hostname>`
3. **Actual switch:** `sudo nixos-rebuild switch --flake .#<hostname> --impure`
4. **Rollback if needed:** `sudo nixos-rebuild switch --rollback`

Before committing changes, always run a build command to verify syntax and dependencies.

## Repository Structure

```
.
├── flake.nix              # Main entry point, defines nixosConfigurations
├── flake.lock             # Locked dependencies (commit after updates)
├── hosts/
│   ├── common.nix         # Shared configuration across all hosts
│   ├── laptop/            # rivendell host config
│   │   ├── configuration.nix
│   │   └── home.nix
│   └── workstation/       # minas-tirith host config
│       ├── configuration.nix
│       └── home.nix
├── modules/               # Reusable configuration modules
│   ├── programs.nix       # User applications
│   ├── plasma.nix         # KDE Plasma configuration
│   └── dev/               # Development environment
│       ├── default.nix    # Aggregates all dev modules
│       ├── cli.nix        # Bash, git, zoxide, fzf
│       ├── lazy.nix       # Neovim with LazyVim
│       ├── starship.nix   # Shell prompt
│       ├── tools.nix      # Language toolchains
│       ├── vscode.nix     # VSCode configuration
│       └── vm.nix         # Virtualization setup
└── config/                # Non-Nix configuration files
    ├── wallpaper.png
    ├── catppuccin-macchiato-grub-theme/
    ├── nvim/              # LazyVim configuration
    └── eduroam/           # WiFi setup scripts
```

## Code Style Guidelines

### Formatting

**Indentation:** Use 2 spaces consistently (no tabs)

**Line length:** No strict limit, but prefer breaking long attribute sets into multiple lines

**Function signatures:**
```nix
{ pkgs, ... }:                    # Simple, most common
{ pkgs, lib, ... }:               # When lib functions needed
{ pkgs, lib, config, ... }:       # When referencing config values
```

### Naming Conventions

- **Files:** Lowercase with hyphens for multi-word names (e.g., `hardware-configuration.nix`)
- **Attributes:** camelCase for multi-word attributes (e.g., `defaultBranch`, `autoUpgrade`)
- **Variables:** camelCase in let bindings
- **Hostnames:** Lowercase (rivendell, minas-tirith)

### Attribute Sets

```nix
# Inline for short configurations
extraGroups = [ "networkmanager" "wheel" "docker" ];

# Multi-line for longer configurations (2-space indent)
boot.loader.grub = {
  enable = true;
  device = "nodev";
  efiSupport = true;
};

# With keyword for package lists
environment.systemPackages = with pkgs; [
  git
  vim
  htop
];
```

### String Literals

- **Double quotes** for simple strings: `"rivendell"`
- **Multi-line strings** (double single-quotes) for heredocs: `''...''`
- **String interpolation:** `"${pkgs.package}/path"`
- **Paths:** Use bare paths when possible: `./relative/path` or `/absolute/path`

### Imports

Always use relative imports for local files:

```nix
imports = [
  ../common.nix                    # Parent directory
  ../../modules/dev                # Module directory (picks up default.nix)
  ../../modules/programs.nix       # Specific file
  /etc/nixos/hardware-configuration.nix  # Absolute for system-generated
];
```

### Comments

```nix
# Section headers
# boot

# Inline explanations
efiSupport = true;  # Required for UEFI systems

# TODOs (note typo pattern from codebase)
# todo for fully declaritiv config overrideConfig = true;
```

### Module Organization

- Each module should be self-contained
- Use `default.nix` in directories to aggregate sub-modules
- Modules should export configurations directly (no complex option definitions)
- Group related configurations together with section comments

### Error Handling

Nix expressions should be total functions. Error handling patterns:

```nix
# Use lib.optionalAttrs for conditional config
lib.optionalAttrs (config.programs.git.enable) {
  programs.git.userName = "...";
};

# Use mkIf for conditional modules
config = lib.mkIf config.services.foo.enable {
  # ...
};
```

## Development Workflow

1. **Make changes** to .nix files
2. **Test build** with `nixos-rebuild build --flake .#$(hostname)`
3. **Apply changes** with `nrs` (or `sudo nixos-rebuild switch --flake .#<hostname> --impure`)
4. **If something breaks**, rollback with `sudo nixos-rebuild switch --rollback`
5. **Commit changes** with descriptive, lowercase, imperative messages

## Important Notes

- **Hardware configuration:** `hardware-configuration.nix` is gitignored (host-specific)
- **Impure flag:** Required for some builds (`--impure`)
- **Flake updates:** Run `nfu` to update inputs, check `flake.lock` diff
- **Home Manager:** User-level configs in `home.nix`, system-level in `configuration.nix`
- **Stylix:** System-wide theming applied via `stylix.base16Scheme` (Catppuccin Macchiato)

## Git Conventions

**Commit message style** (from repo history):
- Lowercase, imperative mood
- Descriptive but concise
- Examples:
  - "add VM configuration and update VSCode settings managment"
  - "fix delay when login after reboot"
  - "update flake inputs"

## Common Pitfalls

1. **Forgetting --impure flag:** Some builds require it
2. **Not testing before committing:** Always build first
3. **Breaking both hosts:** Test changes on one host before applying to both
4. **Syntax errors:** Use `nix flake check` to validate
5. **Missing imports:** Ensure all dependencies are imported in `flake.nix`
6. **Path issues:** Use relative paths for local files, ensure they're tracked in git

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Language Basics](https://nixos.wiki/wiki/Nix_Expression_Language)
