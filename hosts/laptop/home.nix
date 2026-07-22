_: {
  imports = [
    ../home.nix
    ../../modules/linux/home/desktop/niri
    ../../modules/linux/home/desktop/plasma.nix
  ];

  xdg.mimeApps.defaultApplications =
    let
      audio = [
        "audio/aac"
        "audio/flac"
        "audio/mp4"
        "audio/mpeg"
        "audio/ogg"
        "audio/opus"
        "audio/x-wav"
      ];
      video = [
        "video/mp4"
        "video/mpeg"
        "video/ogg"
        "video/quicktime"
        "video/webm"
        "video/x-matroska"
        "video/x-msvideo"
      ];
      image = [
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/webp"
      ];
    in
    { "application/pdf" = "org.kde.okular.desktop"; }
    // builtins.listToAttrs (map (t: { name = t; value = "mpv.desktop"; }) (audio ++ video))
    // builtins.listToAttrs (map (t: { name = t; value = "org.kde.gwenview.desktop"; }) image);
}
