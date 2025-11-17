{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        alias nx='code /etc/nixos'
        alias ls='eza -lh --group-directories-first --icons=auto'
        alias neofetch='fastfetch'
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [ "--cmd cd" ];
    };

    git = {
      enable = true;
      userName = "Public User";
      userEmail = "user@example.invalid";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    btop
    fastfetch
    gh
    ripgrep
    eza
    fd
    tmux

    (writeShellScriptBin "update" ''
      #!/usr/bin/env bash

      echo "🔄 Updating NixOS system..."
      sudo nixos-rebuild switch --upgrade || {
        echo "❌ NixOS rebuild failed!"
        exit 1
      }

      echo "🗑️ Cleaning up NixOS system..."
      sudo nix-collect-garbage -d --delete-older-than 7d

      echo "🔄 Updating Flatpak packages..."
      flatpak update -y

      echo "✅ System update complete!"
    '')
  ];

  home.sessionVariables = {
    tERMINAL = "ghostty";
    jAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  # Ghostty configuration
  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Frappe"
  '';
}
