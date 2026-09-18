{ pkgs, ... }:
pkgs.mkShell {
  name = "docker-shell";
  packages = with pkgs; [
    lazydocker
  ];
}
