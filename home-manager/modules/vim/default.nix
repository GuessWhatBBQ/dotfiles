{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [ ];
    hm-activation = true;
    backup = false;
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };

  home.file.".SpaceVim.d" = {
    source = ./SpaceVim.d;
  };
}
