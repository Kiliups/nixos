{ ... }:
{
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = true;
      selection_wrap = true;
      hide_action_hints = true;

      placeholders."default" = {
        input = " Search...";
        list = "No Results";
      };

      keybinds.quick_activate = [ ];

      columns.symbols = 1;

      providers = {
        max_results = 256;
        default = [
          "desktopapplications"
          "websearch"
        ];
        prefixes = [
          {
            prefix = "/";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "symbols";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = "$";
            provider = "clipboard";
          }
        ];
      };

      /*
        TODO
          emergencies = [
            {
              text = "Restart Walker";
              command = "omarchy-restart-walker";
            }
          ];
      */
    };
  };
}
