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
  inherit icon categories;
  terminal = false;
  startupNotify = true;
}
// {
  webapp = {
    inherit id name argv;
  };
}
