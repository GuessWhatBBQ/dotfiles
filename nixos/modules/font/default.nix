{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Meslo"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
}
