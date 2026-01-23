# NixOS Configuration

Personal Nixos configuration with homemanager for my personal gaming machine and my notebook

# Quickstart

1. enable flake support in your configuration.nix:

   - nix.settings.experimental-features = ["nix-command" "flakes"];
   - sudo nixos-rebuild switch

2. Clone this repository to `~/.config/nixos`
3. run sudo nixos-rebuild switch --flake .#{hostname} --impure // hostname is minas-tirth or rivendell defined in the configuration.nix files

# Manual Configuration

- [ ] **VsCode**: Catppuccin Theme extension must be manually installed due to errors
- [ ] **KDE Shortcuts**: Shortcuts are configured but some have overlaping system shortcuts which need to be overwritten
- [ ] **eduroam** in ./config/eduroam there are two scripts to add eduroam but you need to download p12 from https://www.easyroam.de/home and extract it using the extract script in the folder (you may need to change read permissions if it does not work)

# Theming

- **Catppuccin Macchiato**: Applied system-wide via Stylix
- **GRUB Theme**: Catppuccin Macchiato bootloader theme
- **VSCode**: Catppuccin Theme extension must be installed manually

# Updating

1. update
   ```bash
   nrsu
   ```
2. rebuild
   ```bash
   nrs
   ```
