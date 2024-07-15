{ pkgs, ... }:
{

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    discord
    betterdiscordctl
    maestral-gui
    baobab

    python3
    nixfmt-rfc-style
  ];
  environment.shells = with pkgs; [ zsh ];
}
