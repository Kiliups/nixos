{ pkgs, ... }:
{
  home.packages = with pkgs; [
   teams-for-linux
    zotero
    eduvpn-client
  ];

}
