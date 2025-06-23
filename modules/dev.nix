{ config, pkgs, ... }:
{
  programs = {

    bash = {
      enable = true;
      bashrcExtra = ''
        alias nrs='sudo nixos-rebuild switch'
        alias nrt='sudo nixos-rebuild test'
        alias hms='home-manager switch'
        alias hmn='home-manager news'
      '';
    };

    git = {
      enable = true;
      userName = "Kilian Mayer";
      userEmail = "mayer-kilian@gmx.de";
    };

    vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          esbenp.prettier-vscode
          eamodio.gitlens
          github.copilot
          github.copilot-chat
          vscjava.vscode-java-pack
          svelte.svelte-vscode
        ];
        userSettings = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          # Optimize imports on save
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
          "editor.formatOnPaste" = true;
        };
      };
    };

  };

  home.packages = with pkgs; [
    ghostty
    bun
    jdk21
    jetbrains.idea-ultimate
    maven
    gradle
    python3
    python3Packages.pip
    docker
    docker-compose
    htop
  ];

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Dracula+"
    window-decoration = client
  '';
}
