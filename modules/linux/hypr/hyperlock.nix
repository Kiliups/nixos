{ lib, config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = lib.mkForce [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 6;
        }
      ];

      input-field = lib.mkForce [
        {
          size = "260, 52";
          position = "0, -90";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${colors.base05})";
          inner_color = "rgb(${colors.base00})";
          outer_color = "rgb(${colors.base0D})";
          check_color = "rgb(${colors.base0B})";
          fail_color = "rgb(${colors.base08})";
          placeholder_text = "Password...";
        }
      ];

      label = lib.mkForce [
        {
          text = "cmd[update:1000] echo -n $(date +'%H:%M')";
          position = "0, 90";
          font_size = 70;
          color = "rgb(${colors.base05})";
        }
        {
          text = "cmd[update:1000] echo -n $(date +'%A, %d %B')";
          position = "0, 35";
          font_size = 20;
          color = "rgb(${colors.base04})";
        }
      ];
    };
  };

}
