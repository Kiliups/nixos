{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
  };
  
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        alias nrs='sudo nixos-rebuild switch'
        alias nx='code /etc/nixos'
        alias nrsu='sudo nixos-rebuild switch --upgrade'
      '';
    };
    
    git = {
      enable = true;
      userName = "Kilian Mayer";
      userEmail = "mayer-kilian@gmx.de";
      extraConfig = {
        init.defaultBranch = "main";
      };
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
          dart-code.dart-code
          dart-code.flutter
          jnoortheen.nix-ide
          ms-vscode-remote.remote-ssh
        ];
      };
    };
  };

  home.packages = with pkgs; [
    # Terminal & Tools
    ghostty
    btop
    fastfetch
    gh
    
    # Development Tools
    bun
    nodejs
    jdk21
    maven
    gradle
    python3
    python3Packages.pip
    code-cursor
    postman
    dbeaver-bin
    
    # Mobile Development
    android-studio
    flutter
    
    # Document Processing
    miktex
    
    # Containers
    docker
    docker-compose
  ];

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  # Ghostty configuration
  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Dracula+"
    window-decoration = client
  '';

  # Enhanced VSCode settings with Flutter support
  home.activation.vscode-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/Code/User
    if [ ! -f ~/.config/Code/User/settings.json ]; then
      cat > ~/.config/Code/User/settings.json << 'EOF'
    {
      "editor.defaultFormatter": "esbenp.prettier-vscode",
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit"
      },
      "editor.formatOnPaste": true,
    }
    EOF
    fi
  '';

  # Add a service menu for opening directories in VS Code
  xdg.dataFile."kio/servicemenus/vscode-here.desktop".text = ''
    [Desktop Entry]
    Type=Service
    X-KDE-ServiceTypes=KonqPopupMenu/Plugin
    MimeType=inode/directory;
    Actions=vscode-here;
    X-KDE-Priority=TopLevel
    
    [Desktop Action vscode-here]
    Name=Open VS Code here
    Name[de]=Öffne VS Code hier
    Icon=code
    Exec=code %f
  '';
}
