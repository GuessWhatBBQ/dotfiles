{ pkgs, ... }:
pkgs.mkShell {
  name = "node-shell";
  packages = with pkgs; [
    bun
    # nodejs
    # yarn
    # corepack
    typescript
    typescript-language-server
    vscode-langservers-extracted
    prettier
    eslint
  ];
}
