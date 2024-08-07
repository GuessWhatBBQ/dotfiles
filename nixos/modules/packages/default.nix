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
    discord
    betterdiscordctl
    maestral-gui
    baobab
    zoom-us

    audacity
    darktable
    foliate
    gimp-with-plugins
    libreoffice
    logseq
    nomacs
    qalculate-qt
    qbittorrent

    miniserve
    ncdu
    p7zip
    progress
    pulsemixer

    networkmanagerapplet
    dunst

    revanced-cli

    python3
    nixfmt-rfc-style
    nil
    sqlite

    protonvpn-gui
  ];
  environment.shells = with pkgs; [ zsh ];
}
