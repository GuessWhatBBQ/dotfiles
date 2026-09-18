{ pkgs, ... }:
pkgs.mkShell {
  name = "nix-shell";
  packages = with pkgs; [
    nil
    nixfmt
  ];
}
