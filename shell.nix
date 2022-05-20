{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.docker
    pkgs.nixpkgs-fmt
    (pkgs.python39.withPackages (pypkgs: [ pypkgs.pip ]))
  ];
}
