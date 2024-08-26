{ pkgs, ... }:
{

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.hyprland.enable = true;
  programs.bandwhich.enable = true;

  environment.systemPackages = with pkgs; [
    audacity
    baobab
    betterdiscordctl
    darktable
    discord
    dunst
    foliate
    gimp-with-plugins
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
    protonvpn-gui
    pulsemixer
    python3
    qalculate-qt
    qbittorrent
    revanced-cli
    sqlite
    zoom-us
  ];
  environment.shells = with pkgs; [ zsh ];
}
