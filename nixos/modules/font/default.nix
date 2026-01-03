{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs.nerd-fonts; [
      fira-code
      fira-mono
      symbols-only
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif Bengali"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans Bengali"
        ];
        monospace = [ "Noto Sans Mono" ];
      };
      useEmbeddedBitmaps = true;
    };
  };
}
