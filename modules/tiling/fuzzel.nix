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
        background = "${colors.base00}";
        text = "${colors.base05}";
        prompt = "${colors.base0D}";
        placeholder = "${colors.base03}";
        input = "${colors.base05}";
        match = "${colors.base0A}";
        selection = "${colors.base02}";
        selection-text = "${colors.base05}";
        selection-match = "${colors.base0A}";
        counter = "${colors.base04}";
        border = "${colors.base0D}";
      };

      border = {
        width = 1;
        radius = 4;
      };
    };
  };
}
