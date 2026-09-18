{ pkgs, ... }:
let
  # Libraries that C-extensions (like numpy) need at runtime
  runtimeLibs = with pkgs; [
    stdenv.cc.cc.lib
  ];
in
pkgs.mkShell {
  name = "python-shell";
  packages = with pkgs; [
    python3
    uv
    poetry
    copier
    black
    ruff
    ty
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH"
  '';
}
