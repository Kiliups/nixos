{ config, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  xdg.configFile = {
    "niri/config.kdl".text = ''
      include "./cfg/animation.kdl"
      include "./cfg/autostart.kdl"
      include "./cfg/keybinds.kdl"
      include "./cfg/input.kdl"
      include "./cfg/display.kdl"
      include "./cfg/layout.kdl"
      include "./cfg/rules.kdl"
      include "./cfg/misc.kdl"
    '';

    "niri/cfg/animation.kdl".text = ''
      animations {
          workspace-switch {
              spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
          }
          window-open {
              duration-ms 120
              curve "ease-out-quad"
          }
          window-close {
              duration-ms 90
              curve "ease-out-cubic"
          }
          horizontal-view-movement {
              spring damping-ratio=1.0 stiffness=1200 epsilon=0.0001
          }
          window-movement {
              spring damping-ratio=1.0 stiffness=1100 epsilon=0.0001
          }
          window-resize {
              spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
          }
          config-notification-open-close {
              spring damping-ratio=0.8 stiffness=1600 epsilon=0.001
          }
          screenshot-ui-open {
              duration-ms 180
              curve "ease-out-quad"
          }
          overview-open-close {
              spring damping-ratio=1.0 stiffness=1200 epsilon=0.0001
          }
      }
    '';

    "niri/cfg/display.kdl".text = ''
      // Output positions are handled by niri-arrange-displays at startup.
    '';

    "niri/cfg/input.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "de"
              }
              numlock
              repeat-delay 200
              repeat-rate 40
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

          focus-follows-mouse
          workspace-auto-back-and-forth
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
    '';

    "niri/cfg/keybinds.kdl".text = ''
      binds {
          Mod+Shift+Escape { show-hotkey-overlay; }

          Print hotkey-overlay-title="Screenshot: Niri" { screenshot; }
          Ctrl+Print hotkey-overlay-title="Screenshot Focused Display: Niri" { screenshot-screen; }
          Alt+Print hotkey-overlay-title="Screenshot Focused Window: Niri" { screenshot-window; }
          Mod+Shift+S hotkey-overlay-title="Capture and Edit: Satty" { spawn "niri-screenshot"; }
          Mod+Print hotkey-overlay-title="Record Screen: Kooha" { spawn "kooha"; }

          Mod+Return hotkey-overlay-title="Open Terminal: Ghostty" { spawn "ghostty"; }
          Mod+Space hotkey-overlay-title="Open App Launcher" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
          Mod+V hotkey-overlay-title="Clipboard History" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
          Mod+B hotkey-overlay-title="Open Browser: Zen" { spawn "zen-beta"; }
          Mod+E hotkey-overlay-title="Open File Manager: Dolphin" { spawn "dolphin"; }
          Mod+Alt+E hotkey-overlay-title="Open Editor: Kate" { spawn "kate"; }
          Mod+M hotkey-overlay-title="Open Mail: Thunderbird" { spawn "thunderbird"; }
          Mod+L hotkey-overlay-title="Lock Screen" { spawn "dms" "ipc" "call" "lock" "lock"; }
          Mod+Shift+Q hotkey-overlay-title="Session Menu" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
          Mod+Alt+I hotkey-overlay-title="Quick Settings" { spawn "dms" "ipc" "call" "control-center" "toggle"; }
          Mod+Alt+N hotkey-overlay-title="Notifications" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
          Mod+Alt+Comma hotkey-overlay-title="Desktop Settings" { spawn "dms" "ipc" "call" "settings" "toggle"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "increment" "5"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "decrement" "5"; }
          XF86AudioMute allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "mute"; }
          XF86AudioMicMute allow-when-locked=true { spawn "dms" "ipc" "call" "mic" "mute"; }
          XF86AudioNext allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "previous"; }
          XF86AudioPlay allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
          XF86AudioPause allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5"; }

          Mod+Q repeat=false { close-window; }

          Mod+Left { focus-column-left; }
          Mod+Alt+H { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Alt+L { focus-column-right; }
          Mod+Up { focus-window-up; }
          Mod+Alt+K { focus-window-up; }
          Mod+Down { focus-window-down; }
          Mod+Alt+J { focus-window-down; }

          Mod+Ctrl+Left { move-column-left; }
          Mod+Ctrl+H { move-column-left; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+L { move-column-right; }
          Mod+Ctrl+Up { move-window-up; }
          Mod+Ctrl+K { move-window-up; }
          Mod+Ctrl+Down { move-window-down; }
          Mod+Ctrl+J { move-window-down; }

          Mod+Home { focus-column-first; }
          Mod+End { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End { move-column-to-last; }

          Mod+Shift+Left { focus-monitor-left; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+Up { focus-monitor-up; }
          Mod+Shift+Down { focus-monitor-down; }

          Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }

          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight { focus-column-right; }
          Mod+WheelScrollLeft { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft { move-column-left; }

          Mod+Shift+WheelScrollDown { focus-column-right; }
          Mod+Shift+WheelScrollUp { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }

          Mod+Tab { focus-workspace-previous; }

          Ctrl+Alt+Tab { focus-monitor-next; }
          Ctrl+Alt+Shift+Tab { focus-monitor-previous; }

          Mod+Ctrl+F { expand-column-to-available-width; }
          Mod+C { center-column; }
          Mod+Ctrl+C { center-visible-columns; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Plus { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Plus { set-window-height "+10%"; }

          Mod+T { toggle-window-floating; }
          Mod+F { maximize-column; }
          Mod+Comma { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }
          Mod+W { toggle-column-tabbed-display; }
          Ctrl+Up repeat=false { toggle-overview; }
          Mod+O repeat=false { toggle-overview; }
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
          Mod+Shift+P { power-off-monitors; }
          Ctrl+Alt+Delete { quit; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }
      }
    '';

    "niri/cfg/layout.kdl".text = ''
      layout {
          gaps 8
          center-focused-column "never"
          background-color "transparent"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          struts {}

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
    '';

    "niri/cfg/misc.kdl".text = ''
      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      environment {
          ELECTRON_OZONE_PLATFORM_HINT "auto"
          XDG_CURRENT_DESKTOP "niri"
      }

      debug {
          honor-xdg-activation-with-invalid-serial
      }

      hotkey-overlay {
          skip-at-startup
      }
    '';

    "niri/cfg/rules.kdl".text = ''
      window-rule {
          geometry-corner-radius 8
          clip-to-geometry true
      }

      window-rule {
          match app-id="steam"
          exclude title=r#"^[Ss]team$"#
          open-floating true
      }

      window-rule {
          match app-id="satty"
          open-floating true
      }

      window-rule {
          match app-id=r#"^(org\.freedesktop\.impl\.portal\.desktop\.kde|xdg-desktop-portal-kde)$"#
          open-floating true
      }

      window-rule {
          match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
          default-floating-position x=10 y=10 relative-to="bottom-right"
          open-focused false
      }

      layer-rule {
          match namespace="^dms:wallpaper"
          place-within-backdrop true
      }
    '';
  };
}
