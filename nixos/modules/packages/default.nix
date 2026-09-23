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

  environment.systemPackages = with pkgs; [
    # antigravity-fhs
    audacity
    awww
    baobab
    betterdiscordctl
    darktable
    # devenv
    discord
    dunst
    foliate
    gimp-with-plugins
    glances
    google-chrome
    # gns3-gui
    grimblast
    kile
    libinput
    libreoffice
    logseq
    # lunarvim
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
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    revanced-cli
    satty
    # texliveFull
    wl-clipboard-rs
    ytmdesktop
  ];
}
