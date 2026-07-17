{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  theme = pkgs.writeText "dms-catppuccin-macchiato.json" (
    builtins.toJSON {
      dark = {
        name = "Catppuccin Macchiato";
        primary = colors.base0D;
        primaryText = colors.base00;
        primaryContainer = colors.base02;
        secondary = colors.base0E;
        surface = colors.base01;
        surfaceText = colors.base05;
        surfaceVariant = colors.base02;
        surfaceVariantText = colors.base04;
        surfaceTint = colors.base0D;
        background = colors.base00;
        backgroundText = colors.base05;
        outline = colors.base03;
        surfaceContainerLowest = "#181926";
        surfaceContainerLow = "#1e2030";
        surfaceContainer = colors.base01;
        surfaceContainerHigh = colors.base02;
        surfaceContainerHighest = "#5b6078";
        error = colors.base08;
        warning = colors.base0A;
        info = colors.base0C;
        matugen_type = "scheme-tonal-spot";
      };
    }
  );
  settings = pkgs.writeText "dms-settings.json" (
    builtins.toJSON {
      currentThemeName = "custom";
      customThemeFile = "${theme}";
      cornerRadius = 8;
      dankBarInnerPadding = 6;
      dankBarTransparency = 0.8;
      dankBarNoBackground = true;
      showWorkspaceIndex = true;
      weatherEnabled = false;
      showWeather = false;
      showCpuUsage = false;
      showMemUsage = false;
      showCpuTemp = false;
      showGpuTemp = false;
      audioVisualizerEnabled = false;
      gtkThemingEnabled = false;
      qtThemingEnabled = false;
      runDmsMatugenTemplates = false;
      matugenTemplateNiri = false;
      updaterHideWidget = true;
      updaterCheckOnStart = false;
      lockBeforeSuspend = true;
      loginctlLockIntegration = true;
      lockScreenWallpaperPath = "${config.stylix.image}";
    }
  );
in
{
  home.activation.dmsSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD rm -f "$HOME/.config/DankMaterialShell/settings.json"
    $DRY_RUN_CMD install -Dm644 ${settings} "$HOME/.config/DankMaterialShell/settings.json"
  '';

  xdg.stateFile."DankMaterialShell/session.json".text = builtins.toJSON {
    isLightMode = false;
    wallpaperPath = "${config.stylix.image}";
    perMonitorWallpaper = false;
    wallpaperCyclingEnabled = false;
  };

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    Unit = {
      Description = "KDE PolicyKit authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Service = {
      ExecStart = lib.getExe' pkgs.kdePackages.polkit-kde-agent-1 "polkit-kde-authentication-agent-1";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
