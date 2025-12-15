{ lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      palette = "base16";

      format = lib.concatStrings [
        "$nix_shell"
        "$username"
        "$directory"
        "$git_branch"
        "$character"
      ];

      nix_shell = {
        format = "[$symbol]($style)";
        symbol = "❄️ ";
        style = "bold blue";
      };

      username = {
        show_always = true;
        format = "[$user]($style) in ";
        style_user = "bold blue";
      };

      directory = {
        format = "[$path]($style)";
        style = "bold green";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        format = " on [\\[$branch\\]]($style)";
        style = "bold purple";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };
}
