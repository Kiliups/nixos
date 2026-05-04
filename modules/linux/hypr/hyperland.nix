{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    networkmanagerapplet # networkmanager
    kdePackages.kwalletmanager # kwallet + secret service backend
    kdePackages.polkit-kde-agent-1 # auth dialogs in hyprland
    brightnessctl # brightness keys
    pavucontrol # audio control
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;
        repeat_rate = 35;
        repeat_delay = 200;
        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
        };
      };

      monitor = [
        "eDP-1,preferred,1147x1440,1.33"
        "DP-3,preferred,0x0,1"
        "DP-2,preferred,0x0,1"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "walker";
      "$reload_waybar" = "pkill waybar; waybar";
      "$mainMod" = "SUPER";

      "exec-once" = [
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "${pkgs.kdePackages.kwallet}/bin/kwalletd6"
        "${pkgs.kdePackages.kwallet}/bin/ksecretd"
        "sleep 2 && nm-applet --indicator"
        "waybar"
      ];

      # ---------------------------------------------------------------------------------
      # https://github.com/basecamp/omarchy/blob/dev/default/hypr/looknfeel.conf

      # https://wiki.hypr.land/Configuring/Basics/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        resize_on_border = false;

        # Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      # https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
      decoration = {
        rounding = 8;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
        };

        # https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          special = true;
          brightness = 0.60;
          contrast = 0.75;
        };
      };

      # https://wiki.hypr.land/Configuring/Basics/Variables/#group
      group = {
        groupbar = {
          font_size = 12;
          font_family = "monospace";
          font_weight_active = "ultraheavy";
          font_weight_inactive = "normal";

          indicator_height = 0;
          indicator_gap = 5;
          height = 22;
          gaps_in = 5;
          gaps_out = 0;

          gradients = true;
          gradient_rounding = 0;
          gradient_round_only_edges = false;
        };
      };

      # https://wiki.hypr.land/Configuring/Basics/Variables/#animations
      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 3.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
          "specialWorkspace, 1, 3, easeOutQuint, slidevert"
        ];
      };

      # See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      # See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hypr.land/Configuring/Basics/Variables/#misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_scale_notification = true;
        focus_on_activate = true;
        anr_missed_pings = 3;
        on_focus_under_fullscreen = 1;
      };

      # https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      # Auto toggle scratchpad on switching workspace from scratchpad
      binds = {
        hide_special_on_workspace_change = true;
      };
      # ----------------------------------------------------------------------------------

      # ----------------------------------------------------------------------------------
      # https://github.com/basecamp/omarchy/blob/dev/default/hypr/envs.conf
      env = [
        # Cursor size
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"

        # Force all apps to use Wayland
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland,x11"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "XDG_SESSION_TYPE,wayland"

        # Allow better support for screen sharing (Google Meet, Discord, etc)
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      xwayland = {
        force_zero_scaling = true;
      };
      # ----------------------------------------------------------------------------------

      gesture = [
        "3, horizontal, workspace"
      ];

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, R, exec, $reload_waybar"
        "$mainMod, G, fullscreen, 0"
        "$mainMod, P, pseudo,"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, F, exec, $fileManager"
        "$mainMod, B, exec, zen-beta"
        "$mainMod, N, exec, obsidian"
        "$mainMod, M, exec, spotify"
        "$mainMod, E, exec, thunderbird"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, Tab, workspace, e+1"
        "$mainMod SHIFT, Tab, workspace, e-1"
      ];

      binde = [
        "$mainMod ALT, h, resizeactive, -20 0"
        "$mainMod ALT, l, resizeactive, 20 0"
        "$mainMod ALT, k, resizeactive, 0 -20"
        "$mainMod ALT, j, resizeactive, 0 20"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
