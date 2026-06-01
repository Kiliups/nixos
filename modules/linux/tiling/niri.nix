{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  wallpaper = toString osConfig.stylix.image;
in
{
  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
  ];

  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
        hide-not-bound
    }

    input {
        keyboard {
            repeat-delay 200
            repeat-rate 35
        }

        touchpad {
            tap
            dwt
            drag true
            drag-lock
            natural-scroll
            accel-speed 0.2
            scroll-method "two-finger"
            click-method "clickfinger"
            tap-button-map "left-right-middle"
        }

        focus-follows-mouse max-scroll-amount="0%"
    }

    gestures {
        dnd-edge-view-scroll {
            trigger-width 80
            delay-ms 80
            max-speed 2500
        }

        dnd-edge-workspace-switch {
            trigger-height 80
            delay-ms 80
            max-speed 2500
        }

        hot-corners {
            top-left
        }
    }

    spawn-at-startup "swaybg" "-i" "${wallpaper}" "-m" "fill"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"

    binds {
        Super+Space { spawn "fuzzel"; }
        Super+K { show-hotkey-overlay; }

        Super+Return { spawn "ghostty"; }
        Super+Shift+Return { spawn "ghostty" "-e" "tmux"; }
        Super+B { spawn "zen-beta"; }
        Super+E { spawn "dolphin"; }
        Super+M { spawn "thunderbird"; }

        Super+Q repeat=false { close-window; }
        Super+T { toggle-window-floating; }
        Super+F { fullscreen-window; }
        Super+Ctrl+F { maximize-window-to-edges; }
        Super+Alt+F { expand-column-to-available-width; }
        Super+L { toggle-column-tabbed-display; }
        Super+O repeat=false { toggle-overview; }

        Super+Left { focus-column-left; }
        Super+Right { focus-column-right; }
        Super+Up { focus-window-up; }
        Super+Down { focus-window-down; }

        Super+Shift+Left { move-column-left; }
        Super+Shift+Right { move-column-right; }
        Super+Shift+Up { move-window-up; }
        Super+Shift+Down { move-window-down; }

        Super+Tab { focus-workspace-down; }
        Super+Shift+Tab { focus-workspace-up; }
        Super+Ctrl+Tab { focus-workspace-previous; }

        Ctrl+Alt+Tab { focus-monitor-next; }
        Ctrl+Alt+Shift+Tab { focus-monitor-previous; }

        Super+Minus { set-column-width "-10%"; }
        Super+Equal { set-column-width "+10%"; }
        Super+Shift+Minus { set-window-height "-10%"; }
        Super+Shift+Equal { set-window-height "+10%"; }

        Super+1 { focus-workspace 1; }
        Super+2 { focus-workspace 2; }
        Super+3 { focus-workspace 3; }
        Super+4 { focus-workspace 4; }
        Super+5 { focus-workspace 5; }
        Super+6 { focus-workspace 6; }
        Super+7 { focus-workspace 7; }
        Super+8 { focus-workspace 8; }
        Super+9 { focus-workspace 9; }
        Super+0 { focus-workspace 10; }

        Super+Shift+1 { move-window-to-workspace 1; }
        Super+Shift+2 { move-window-to-workspace 2; }
        Super+Shift+3 { move-window-to-workspace 3; }
        Super+Shift+4 { move-window-to-workspace 4; }
        Super+Shift+5 { move-window-to-workspace 5; }
        Super+Shift+6 { move-window-to-workspace 6; }
        Super+Shift+7 { move-window-to-workspace 7; }
        Super+Shift+8 { move-window-to-workspace 8; }
        Super+Shift+9 { move-window-to-workspace 9; }
        Super+Shift+0 { move-window-to-workspace 10; }

        Super+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Super+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }

        Super+S { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
    }

    layout {
        gaps 5
        background-color "${colors.base00}"

        focus-ring {
            width 2
            active-color "${colors.base0D}"
            inactive-color "${colors.base03}"
            urgent-color "${colors.base08}"
        }

        border {
            off
            width 1
            active-color "${colors.base0D}"
            inactive-color "${colors.base03}"
            urgent-color "${colors.base08}"
        }

        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=6
            color "${colors.base00}99"
            inactive-color "${colors.base00}66"
        }

        tab-indicator {
            width 3
            gap 5
            length total-proportion=0.75
            position "right"
            gaps-between-tabs 2
            corner-radius 4
            active-color "${colors.base0D}"
            inactive-color "${colors.base03}"
            urgent-color "${colors.base08}"
        }

        insert-hint {
            color "${colors.base0A}"
        }
    }

    overview {
        backdrop-color "${colors.base00}"
    }

    window-rule {
        geometry-corner-radius 4
        clip-to-geometry true
    }
  '';

}
