{ pkgs, ... }:
{
  home.packages = with pkgs; [
    thunderbird
  ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
    };
  };
}
