let
  settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
in
{
  inherit settings;

  nixos = {
    nix.settings = settings;
  };

  darwin = {
    environment.etc."nix/nix.custom.conf" = {
      text = ''
        extra-substituters = ${builtins.concatStringsSep " " settings.extra-substituters}
        extra-trusted-public-keys = ${builtins.concatStringsSep " " settings.extra-trusted-public-keys}
      '';
      knownSha256Hashes = [
        "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"
        "f98adf7c43d9048e06c442e9cd172157afa6d225e908f6e4d725a7b090022513"
      ];
    };
  };
}
