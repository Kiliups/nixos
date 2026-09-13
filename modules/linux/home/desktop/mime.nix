{ lib, pkgs, ... }:
{
  # home-manager must not overwrite the mimeapps.list this service writes.
  xdg.mimeApps.enable = lib.mkForce false;

  systemd.user.services.niri-mime-defaults = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "niri-mime-defaults" ''
        ${pkgs.xdg-utils}/bin/xdg-mime default zen-beta.desktop text/html application/xhtml+xml x-scheme-handler/http x-scheme-handler/https

        [ -e "$HOME/.config/mimeapps.list" ] && exit 0

        set_default_file_handler() {
          local desktop="$1" prefix="$2" file="$3"
          local mimes="$(${pkgs.gnused}/bin/sed -n 's/^MimeType=//p' "$file")"
          for mime in ''${mimes//;/ }; do
            case "$mime" in
              "$prefix"/*) ${pkgs.xdg-utils}/bin/xdg-mime default "$desktop" "$mime" ;;
            esac
          done
        }

        ${pkgs.xdg-utils}/bin/xdg-mime default okularApplication_pdf.desktop application/pdf
        set_default_file_handler org.kde.gwenview.desktop image ${pkgs.kdePackages.gwenview}/share/applications/org.kde.gwenview.desktop
        set_default_file_handler mpv.desktop video ${pkgs.mpv}/share/applications/mpv.desktop
      '';
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
