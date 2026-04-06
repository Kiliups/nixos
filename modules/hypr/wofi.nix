{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 350;
      location = "center";
      show = "drun";
      prompt = "Suche...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };

    style = ''
      * {
        font-family: 'JetBrainsMono Nerd Font', monospace;
        font-size: 14px;
      }

      window {
        margin: 0px;
        padding: 12px;
        background-color: #${colors.base01};
        opacity: 0.95;
        border-radius: 8px;
      }

      #inner-box {
        margin: 0;
        padding: 0;
        border: none;
        background-color: #${colors.base01};
      }

      #outer-box {
        margin: 0;
        padding: 12px;
        border: none;
        background-color: #${colors.base01};
        border-radius: 8px;
      }

      #scroll {
        margin: 0;
        padding: 0;
        border: none;
        background-color: #${colors.base01};
      }

      #input {
        margin: 0;
        padding: 8px;
        border: none;
        background-color: #${colors.base01};
        color: @text;
      }

      #input:focus {
        outline: none;
        box-shadow: none;
        border: none;
      }

      #text {
        margin: 6px;
        border: none;
        color: #${colors.base06};
      }

      #entry {
        background-color: #${colors.base01};
      }

      #entry:selected {
        outline: none;
        border: none;
      }

      #entry:selected #text {
        color: #${colors.base06};
      }
    '';
  };
}
