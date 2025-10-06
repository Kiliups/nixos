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
    jetbrains.idea-ultimate
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
    android-tools  # This provides adb that works on NixOS
    
    # Graphics & System
    mesa-demos
    google-chrome  # For Flutter web development
    
    # Document Processing
    miktex
    
    # Containers
    docker
    docker-compose
  ];

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
    # Flutter & Android
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
    CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";

    # Ensure NixOS android-tools comes first in PATH
    PATH = "${pkgs.android-tools}/bin:${config.home.homeDirectory}/Android/Sdk/emulator:${config.home.homeDirectory}/Android/Sdk/platform-tools:${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin:$PATH";
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

  # Create a script to fix Android Studio SDK conflicts
  home.file.".local/bin/fix-android-sdk".source = pkgs.writeScript "fix-android-sdk" ''
    #!/bin/bash
    # This script replaces the Android Studio SDK's problematic binaries
    # with symlinks to the NixOS versions
    
    SDK_PATH="$HOME/Android/Sdk"
    
    if [ -d "$SDK_PATH" ]; then
      echo "Fixing Android SDK binaries..."
      
      # Backup original adb if it exists
      if [ -f "$SDK_PATH/platform-tools/adb" ] && [ ! -L "$SDK_PATH/platform-tools/adb" ]; then
        mv "$SDK_PATH/platform-tools/adb" "$SDK_PATH/platform-tools/adb.backup"
        echo "Backed up original adb"
      fi
      
      # Create symlink to NixOS adb
      mkdir -p "$SDK_PATH/platform-tools"
      ln -sf "${pkgs.android-tools}/bin/adb" "$SDK_PATH/platform-tools/adb"
      echo "Created symlink to NixOS adb"
      
      # Also link fastboot if it exists
      if [ -f "$SDK_PATH/platform-tools/fastboot" ] && [ ! -L "$SDK_PATH/platform-tools/fastboot" ]; then
        mv "$SDK_PATH/platform-tools/fastboot" "$SDK_PATH/platform-tools/fastboot.backup"
      fi
      ln -sf "${pkgs.android-tools}/bin/fastboot" "$SDK_PATH/platform-tools/fastboot"
      echo "Created symlink to NixOS fastboot"
      
      echo "Android SDK fix complete!"
    else
      echo "Android SDK not found at $SDK_PATH"
      echo "Please install Android SDK through Android Studio first"
    fi
  '';
}