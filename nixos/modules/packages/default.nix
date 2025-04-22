{ pkgs, ... }:
{

  programs.bandwhich.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
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
    devenv
    discord
    dunst
    foliate
    gimp-with-plugins
    glances
    kile
    libinput
    libreoffice
    logseq
    maestral-gui
    miniserve
    ncdu
    networkmanagerapplet
    nil
    nixfmt-rfc-style
    nomacs
    nwg-look
    p7zip
    progress
    pulsemixer
    qalculate-qt
    qbittorrent
    revanced-cli
    sqlite
    swww
  ];
  environment.shells = with pkgs; [ zsh ];
}
