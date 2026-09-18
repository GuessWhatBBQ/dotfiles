{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix4nvchad.homeManagerModules.default
  ];

  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [ ];
    hm-activation = true;
    backup = false;
  };
}
