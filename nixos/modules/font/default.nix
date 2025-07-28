{ pkgs, ... }:
{
  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    fira-mono
    symbols-only
  ];
}
