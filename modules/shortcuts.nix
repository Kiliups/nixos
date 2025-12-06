{ ... }:
{
  programs.plasma = {
    enable = true;

    shortcuts = {
      # Window Management
      kwin = {
        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Tab";

        "Window Close" = "Meta+Q";
        "Window Maximize" = "Meta+CTRL+ALT+Up";
        "Window Minimize" = "Meta+CTRL+ALT+Down";
      };

      # Application Launchers (Hyprland-style)
      "org.kde.dolphin.desktop" = {
        "_launch" = "Meta+F"; # File Manager
      };

      "zen-beta.desktop" = {
        "_launch" = "Meta+B"; # Browser
      };

      "code.desktop" = {
        "_launch" = "Meta+C"; # Code/VSCode
      };

      "thunderbird.desktop" = {
        "_launch" = "Meta+E"; # Email
      };

      "com.mitchellh.ghostty.desktop" = {
        "_launch" = "Meta+Return"; # Terminal (Hyprland uses Super+Return)
      };

      "spotify.desktop" = {
        "_launch" = "Meta+M"; # Music
      };

      "obsidian.desktop" = {
        "_launch" = "Meta+N"; # Notes
      };

      "org.kde.krunner.desktop" = {
        "_launch" = "Meta+Space"; # Application launcher (like dmenu/rofi)
      };

      "systemsettings.desktop" = {
        "_launch" = "Meta+I"; # System Settings
      };
    };
  };
}
