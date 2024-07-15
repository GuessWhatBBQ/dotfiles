{ inputs, pkgs, lib, ... }:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{

  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  # configure spicetify :)
  programs.spicetify =
    {
      enable = true;
      theme = spicePkgs.themes.Sleek;
      colorScheme = "Cherry";

      enabledExtensions = with spicePkgs.extensions; [];
    };
}
