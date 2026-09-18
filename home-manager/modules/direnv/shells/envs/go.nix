{ pkgs, ... }:
pkgs.mkShell {
  name = "go-shell";
  packages = with pkgs; [
    go
    gopls
    gofumpt
    gomodifytags
    gore
    gotests
    gotools
  ];

  shellHook = ''
    export GOROOT="${pkgs.go}/share/go/"
    export GOPATH="$PWD/.gopath"
    export GOTOOLCHAIN="local"
    export PATH="$GOPATH/bin:$PATH"
  '';
}
