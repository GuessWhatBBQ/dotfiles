{ pkgs, ... }:
pkgs.mkShell {
  name = "common-shell";
  packages = with pkgs; [
    # Spellchecker for doomemacs
    ispell
    hunspell
    hunspellDicts.en_US
  ];
}
