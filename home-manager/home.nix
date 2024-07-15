{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  imports = [
    ./modules/default.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs = {
    overlays = [
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

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
  programs.mpv.enable = true;
  programs.bat.enable = true;
  programs.wezterm.enable = true;

  services.dunst.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
