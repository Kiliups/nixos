{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python313;
    in
    {
      devShells.${system}.default =
        with pkgs;
        mkShell {
          packages = [
            python
            uv
          ];
          env.LD_LIBRARY_PATH = lib.makeLibraryPath [
            stdenv.cc.cc.lib
            zlib
          ];
          shellHook = ''
            if [ ! -d .venv ]; then
              uv venv --python ${python}/bin/python3
            fi

            source .venv/bin/activate

            if [ ! -f pyproject.toml ]; then
              uv init --bare --python ${python.pythonVersion}
            fi
          '';
        };
    };
}
