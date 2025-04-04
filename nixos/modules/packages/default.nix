{ pkgs, ... }:
{

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  programs.bandwhich.enable = true;
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    audacity
    baobab
    betterdiscordctl
    darktable
    discord
    dunst
    foliate
    flutter
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
    nodePackages.typescript-language-server
    nodePackages.prettier
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
    swww
    typescript
    wireguard-tools
    zoom-us
  ];
  environment.shells = with pkgs; [ zsh ];
}
