{ pkgs, ... }:
pkgs.mkShell {
  name = "database-shell";
  packages = with pkgs; [
    sqlite
    supabase-cli
  ];
}
