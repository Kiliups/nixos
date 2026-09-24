{ pkgs }:
let
  version = "2.0.15";
  pname = "opencode-desktop";
  src = pkgs.fetchurl {
    url = "https://opencode.ai/files/bin/${version}/${pname}-${
      if pkgs.stdenv.hostPlatform.isDarwin then "mac-arm64.dmg" else "linux-x86_64.AppImage"
    }";
    hash =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "sha256-ocyWyM3+2CIIMpqTvCyiQT7NRkM4HGKS8Izr1Q5AUPQ="
      else
        "sha256-YeAkjjg+8SjNdJtSPIOCCu4BO4Z/BKWsuf3jtyg05X0=";
  };
  contents = pkgs.appimageTools.extract { inherit pname version src; };
in
if pkgs.stdenv.hostPlatform.isDarwin then
  pkgs.stdenvNoCC.mkDerivation {
    inherit pname version src;
    nativeBuildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p "$out/Applications" "$out/bin"
      cp -R OpenCode.app "$out/Applications/"
      ln -s "$out/Applications/OpenCode.app/Contents/MacOS/OpenCode" "$out/bin/opencode-desktop"
    '';
  }
else
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      mkdir -p "$out/share/applications" "$out/share/icons"
      cp -R ${contents}/usr/share/icons/hicolor "$out/share/icons/"
      cp ${contents}/ai.opencode.desktop.desktop "$out/share/applications/ai.opencode.desktop"
      substituteInPlace "$out/share/applications/ai.opencode.desktop" \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=opencode-desktop --no-sandbox %U'
    '';
  }
