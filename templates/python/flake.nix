{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =
        with pkgs;
        mkShell {
          packages = [
            uv
          ];
          env.LD_LIBRARY_PATH = lib.makeLibraryPath [
            stdenv.cc.cc.lib
            zlib
          ];
          shellHook = ''
            uv venv --python ${python313}/bin/python3
            source .venv/bin/activate
            uv init
          '';
        };
    };
}
