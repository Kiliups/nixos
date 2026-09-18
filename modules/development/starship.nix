{ lib, config, ... }:
let
  defaultSettings = {
    add_newline = false;

    palette = "base16";

    format = lib.concatStrings [
      "$nix_shell"
      "$username"
      "$hostname"
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
      format = "[$user]($style)";
      style_user = "bold blue";
    };

    hostname = {
      format = "[@$hostname]($style)";
      style = "bold yellow";
    };

    directory = {
      format = " in [$path]($style)";
      style = "bold green";
      truncation_length = 3;
      truncate_to_repo = false;
    };

    git_branch = {
      format = " on [\\[$branch\\]]($style)";
      style = "bold purple";
    };

    character = {
      error_symbol = "[❯](bold red)";
      success_symbol = "[❯](bold green)";
    };
  };
in
{
  options.development.starship = {
    enable = lib.mkEnableOption "Starship with a one-line prompt showing the Nix shell indicator, username (plus @hostname over SSH), three-segment directory path, Git branch, and red or green command-status character";
  };

  config = lib.mkIf config.development.starship.enable {
    programs.starship = {
      enable = true;
      settings = defaultSettings;
    };
  };
}
