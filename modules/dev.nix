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
        alias ls='eza -lh --group-directories-first --icons=auto'
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [
        "--cmd cd"
      ];
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
          # latex
          ltex-plus.vscode-ltex-plus
          james-yu.latex-workshop
          tomoki1207.pdf
          # spell checking
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
          golang.go
          rust-lang.rust-analyzer
          ms-python.python
          ms-vscode.cpptools
          vscodevim.vim
        ];
      };
    };
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "update" ''
      #!/usr/bin/env bash
    
      echo "🔄 Updating NixOS system..."
      sudo nixos-rebuild switch --upgrade || {
        echo "❌ NixOS rebuild failed!"
        exit 1
      }

      echo "🗑️ Cleaning up NixOS system..."
      sudo nix-collect-garbage -d --delete-older-than 7d
    
      echo "🔄 Updating Flatpak packages..."
      flatpak update -y || {
        echo "⚠️  Flatpak update failed, but continuing..."
      }
    
      echo "✅ System update complete!"
    '')


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
    go
    golangci-lint
    code-cursor
    zed-editor
    postman
    dbeaver-bin
    opencode
    # rust development
    cargo
    rustc
    gcc
    rustfmt
    clippy
    gdb

    # Eduroam
    openssl

    # Mobile Development
    android-studio
    flutter

    # Document Processing
    miktex
    ltex-ls

    # Containers
    docker
    docker-compose

    # Utilities
    fzf
    zoxide
    ripgrep
    eza
    fd
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
      "files.autoSave": "afterDelay",
      "editor.defaultFormatter": "esbenp.prettier-vscode",
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit"
      },
      "[go]": {
        "editor.defaultFormatter": "golang.go",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": "explicit"
        }
      },
      "[rust]": {
        "editor.defaultFormatter": "rust-lang.rust-analyzer",
        "editor.formatOnSave": true
      },
      "editor.formatOnPaste": true,
      "ltex.language": "de-DE",
      "ltex.enabled": ["latex", "markdown"],
      "ltex.ltex-ls.path": "${pkgs.ltex-ls}/bin/ltex-ls",
      "go.lintTool": "golangci-lint",
      "go.lintOnSave": "package",
      "go.lintFlags": [
        "--fast"
      ],
      "go.useLanguageServer": true,
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
