{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        beautifulLyrics
        betterGenres
        fullAppDisplay
        history
        keyboardShortcut
        lastfm
        songStats
        showQueueDuration
      ];
      theme = spicePkgs.themes.sleek;
      colorScheme = "cherry";
    };
}
