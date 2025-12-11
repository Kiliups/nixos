# NixOS Configuration

Personal NixOS configuration with Home Manager integration.

## 🚀 Quick Start

### Initial Setup

1. Clone this repository to `~/.config/nixos`
2. Build the system configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#
   ```

## 📋 Post-Installation Checklist

### Required Manual Configuration

- [ ] **Nextcloud Client**: Configure Nextcloud desktop client with your account credentials
- [ ] **Thunderbird**: Set up email accounts and preferences in Thunderbird
- [ ] **VS Code Catppuccin Theme**: 
  - The Catppuccin theme is not managed via Nix because it showed errors
  - may be fix in the future by installing catpuccin nix
- [ ] **KDE Shortcuts**: 
  - Shortcuts are configured but some have overlaping system shortcuts which need to be overwritten 
- [ ] **KDE Session Management**: 
  - Configure session restore behavior in System Settings

## 🗂️ Structure

```
.
├── configuration.nix      # System-level NixOS configuration
├── flake.nix             # Flake configuration with inputs/outputs
├── home.nix              # Home Manager entry point
├── config/               # Application configurations
│   ├── nvim/            # Neovim configuration
│   ├── vscode/          # VS Code settings
│   └── wallpaper.png    # Desktop wallpaper
└── modules/             # Modular configuration files
    ├── programs.nix     # System programs
    ├── shortcuts.nix    # Keyboard shortcuts
    └── dev/            # Development tools
        ├── cli.nix      # CLI tools
        ├── vscode.nix   # VS Code extensions
        ├── lazy.nix     # LazyVim setup
        └── tools.nix    # Development utilities
```

## 🔧 Configuration Highlights

### Development Environment

- **VS Code**: Configured with extensions for:
  - Go, Rust, Python, C++
  - Nix IDE support
  - Svelte, Dart/Flutter
  - LaTeX, Markdown
  - Git integration (GitLens)
  - GitHub Copilot
  - Kilo Code

- **Neovim**: LazyVim-based configuration with modern plugins

- **CLI Tools**: Comprehensive development toolchain including:
  - Git, Docker
  - Modern shell utilities (eza, bat, ripgrep, etc.)
  - Development languages and toolchains

### Theming

- **Catppuccin Macchiato**: Applied system-wide via Stylix
- **GRUB Theme**: Catppuccin Macchiato bootloader theme


## 🔄 Updating

### Update Flake Inputs
```bash
nrsu
```

### Rebuild System
```bash
nrs
```

## 📝 Notes
- Configuration uses NixOS 25.11

## 🆘 Troubleshooting

### Theme Issues
- Ensure Stylix is properly configured in [`home.nix`](home.nix:13)
- For VS Code, theme is manually configured in [`config/vscode/settings.json`](config/vscode/settings.json:6)

