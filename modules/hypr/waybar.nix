{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 32;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          # "custom/dropbox"
          "tray"
          "bluetooth"
          "network"
          "wireplumber"
          "cpu"
          "power-profiles-daemon"
          "battery"
        ];
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󱓻";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "ghostty -e btop";
        };
        clock = {
          format = "{:%A %H:%M}";
          format-alt = "{:%d. %B KW%V %Y}";
          tooltip = false;
        };
        network = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = "ghostty -e nmcli";
        };
        battery = {
          interval = 5;
          format = "{capacity}% {icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "Charged ";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          states = {
            warning = 20;
            critical = 10;
          };
        };
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueberry";
        };
        wireplumber = {
          # Changed from "pulseaudio"
          "format" = "";
          format-muted = "󰝟";
          scroll-step = 5;
          on-click = "pavucontrol";
          tooltip-format = "Playing at {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Updated command
          max-volume = 150; # Optional: allow volume over 100%
        };
        tray = {
          spacing = 12;
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            power-saver = "󰡳";
            balanced = "󰊚";
            performance = "󰡴";
          };
        };
      }
    ];

    style = ''
      * {
        border: none;
        border-radius: 0 0 8px 8px;
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
      }

      .modules-left {
        margin-left: 16px;
      }

      .modules-right {
        margin-right: 16px;
      }

      #workspaces button {
        all: initial;
        color: @base04;
        padding: 0 8px;
        margin: 4px 2px;
        border-radius: 4px;
        font-size: inherit;
        font-family: inherit;
        min-width: 12px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: @base0D;
        background: @base02;
      }

      #workspaces button.urgent {
        color: @base00;
        background: @base08;
      }

      #workspaces button.empty {
        color: @base03;
      }

      #workspaces button:hover {
        background: @base01;
        color: @base05;
      }

      #clock {
        font-weight: bold;
        letter-spacing: 0.5px;
      }

      #battery,
      #cpu,
      #network,
      #wireplumber,
      #power-profiles-daemon,
      #bluetooth,
      #tray {
        min-width: 12px;
        padding: 0 12px;
      }

      #battery.warning {
        color: @base09;
      }

      #battery.critical {
        color: @base08;
      }

      tooltip {
        padding: 4px 8px;
        border-radius: 8px;
        border: 1px solid @base0D;
      }
    '';
  };
}
