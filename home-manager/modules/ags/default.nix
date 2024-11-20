{ inputs, pkgs, ... }:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # additional packages to add to gjs's runtime
    extraPackages = [
      inputs.ags.packages.${pkgs.system}.apps
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.bluetooth
      inputs.ags.packages.${pkgs.system}.hyprland
      inputs.ags.packages.${pkgs.system}.mpris
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.notifd
      inputs.ags.packages.${pkgs.system}.tray
      inputs.ags.packages.${pkgs.system}.wireplumber
    ];
  };
}
