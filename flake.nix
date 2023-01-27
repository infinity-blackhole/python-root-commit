{
  description = "Python template project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-22.05";

  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      with import nixpkgs { inherit system; };
      callPackage ./shell.nix { }
    );
  };
}
