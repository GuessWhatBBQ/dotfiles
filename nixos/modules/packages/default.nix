{ pkgs, ... }:
{

  programs.bandwhich.enable = true;
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    package = pkgs.unstable.hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
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
    foliate
    gimp-with-plugins
    google-chrome
    grimblast
    kile
    libinput
    libreoffice
    logseq
    maestral-gui
    miniserve
    ncdu
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
