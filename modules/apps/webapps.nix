{ pkgs, lib }:
{
  name,
  url,
  icon ? null,
  categories ? [ "Network" ],
}:
let
  id = lib.toLower (lib.replaceStrings [ " " ] [ "-" ] name);
  argv = [
    "chromium"
    "--ozone-platform-hint=auto"
    "--app=${url}"
    "--class=${id}"
    "--name=${id}"
  ];
in
pkgs.makeDesktopItem {
  name = id;
  desktopName = name;
  exec = lib.concatStringsSep " " (map (arg: ''"${arg}"'') argv);
  comment = "${name} web app";
  icon =
    if icon != null then
      icon
    else
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle/48@2x/apps/${id}.svg";
  inherit categories;
  terminal = false;
  startupNotify = true;
}
// {
  webapp = {
    inherit id name argv;
  };
}
