{
  description        = "NodeJS Development Environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = ["aarch64-linux"];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs_22
              pkgs.corepack
            ];

            shellHook = ''
              echo "NodeJS Development Environment"
              node --version
            '';
          };
        }
      );
    };
}
