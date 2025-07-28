{ pkgs, inputs, ... }:
{

  programs.bandwhich.enable = true;
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.noisetorch.enable = true;
  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    audacity
    baobab
    betterdiscordctl
    darktable
    # devenv
    discord
    dunst
    foliate
    gimp-with-plugins
    glances
    gns3-gui
    grimblast
    kile
    libinput
    libreoffice
    logseq
    maestral-gui
    miniserve
    ncdu
    networkmanagerapplet
    nomacs
    nwg-look
    p7zip
    progress
    pulsemixer
    qalculate-qt
    qbittorrent
    inputs.quickshell.packages.${system}.default
    revanced-cli
    satty
    swww
    # texliveFull
    wl-clipboard-rs
  ];
}
