{
  description = "Python template project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, devenv, ... }@inputs: {
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      let pkgs = import nixpkgs { inherit system; }; in {
        default = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = self;
          python = pkgs.python3;
          overrides = [
            pkgs.poetry2nix.defaultPoetryOverrides
          ];
        };
      }
    );

    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      let pkgs = import nixpkgs { inherit system; }; in {
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
                hadolint.enable = true;
              };
              packages = [
                pkgs.nixpkgs-fmt
                pkgs.docker
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
                  isort
                  black
                ]))
              ];
            }
          ];
        };
      }
    );
  };
}
