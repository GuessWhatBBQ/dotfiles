{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    ./modules/default.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "guesswhatbbq";
    homeDirectory = "/home/guesswhatbbq";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Add stuff for your user as you see fit:
  # home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.yt-dlp.enable = true;
  programs.aria2.enable = true;
  programs.wezterm.enable = true;
  programs.ranger.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
