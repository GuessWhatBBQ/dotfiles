{ pkgs, ... }:
{

  programs.bandwhich.enable = true;
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.noisetorch.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    audacity
    awww
    baobab
    brightnessctl
    darktable
    ddcutil
    discord
    dunst
    foliate
    gimp-with-plugins
    glances
    google-chrome
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
    pear-desktop
    p7zip
    playerctl
    progress
    pulsemixer
    qalculate-qt
    qbittorrent
    revanced-cli
    satty
    wl-clipboard-rs
  ];
}
