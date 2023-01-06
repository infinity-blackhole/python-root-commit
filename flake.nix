{
  description = "Python template project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, devenv, ... }@inputs: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              pre-commit.hooks = {
                actionlint.enable = true;
                markdownlint.enable = true;
                shellcheck.enable = true;
                nixpkgs-fmt.enable = true;
                statix.enable = true;
                deadnix.enable = true;
              };
              packages = [
                pkgs.nixpkgs-fmt
              ];
            }
            {
              pre-commit.hooks = {
                black.enable = true;
                isort.enable = true;
              };
              packages = [
                (pkgs.python3.withPackages (ps: with ps; [
                  pip
                ]))
              ];
            }
          ];
        };
      }
    );
  };
}
