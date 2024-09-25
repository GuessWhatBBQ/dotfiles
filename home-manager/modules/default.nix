{ inputs, ... } : {
  programs.ags.enable = true;
  imports = [
    # ./ags
    inputs.ags.homeManagerModules.default
    ./alacritty
    ./dunst
    ./emacs
    ./eza
    ./git
    ./hyprland
    ./kdeconnect
    ./mpv
    ./spotify
    ./starship
    ./theme
    ./zsh
  ];
}
