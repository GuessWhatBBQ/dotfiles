{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  capitalize = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
  kdeColorScheme = "Catppuccin${capitalize config.catppuccin.flavor}${capitalize config.catppuccin.accent}";
in
{

  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";

    # KDE apps (Okular, Dolphin, ...) apply Breeze over the Kvantum palette on
    # startup when no color scheme is set and the platform theme isn't "kde".
    kde.settings.kdeglobals.UiSettings.ColorScheme = kdeColorScheme;
  };

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ config.catppuccin.flavor ];
      accents = [ config.catppuccin.accent ];
    })
  ];

  catppuccin = {
    flavor = "mocha";
    kvantum = {
      enable = true;
      apply = true;
    };
  };
}
