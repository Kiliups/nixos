{
  config,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [
    fuzzel
  ];

  stylix.targets.fuzzel.enable = false;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty";
        font = "JetBrainsMono Nerd Font:size=14:weight=medium";
        prompt = "";
        fields = "name,generic,comment,categories,filename,keywords";
        width = 32;
        lines = 10;
        horizontal-pad = 12;
        vertical-pad = 12;
        line-height = 24;
        tabs = 4;
        layer = "overlay";
        exit-on-keyboard-focus-loss = true;
      };

      colors = {
        background = "${colors.base00}ff";
        text = "${colors.base05}ff";
        prompt = "${colors.base0D}ff";
        placeholder = "${colors.base03}ff";
        input = "${colors.base05}ff";
        match = "${colors.base0A}ff";
        selection = "${colors.base02}ff";
        selection-text = "${colors.base05}ff";
        selection-match = "${colors.base0A}ff";
        counter = "${colors.base04}ff";
        border = "${colors.base0D}ff";
      };

      border = {
        width = 1;
        radius = 4;
      };
    };
  };
}
