{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  # The bongocat spedup gif was created by u/PM_ME_YOUR_ANDROID for the reddit
  # post https://www.reddit.com/r/PixelArt/comments/9l7r4i/oc_bongo_cat_sped_up
  #
  # The various material icons svg are downloaded from the jsdelivr cdn as they
  # are bundled as npm packages.
  # They are originally from the following repos:
  # @mdi/svg : https://github.com/Templarian/MaterialDesign
  #            https://cdn.jsdelivr.net/npm/@mdi/svg@latest
  # @material-design-icons/svg :
  #            https://github.com/marella/material-design-icons
  #            https://cdn.jsdelivr.net/npm/@material-design-icons/svg@latest
  bongocat = builtins.fetchurl {
    url = "https://i.redd.it/qf46od2du2q11.gif";
    sha256 = "sha256:1l0b11sj5bplb4ig3bci5g84qw13ly8wx0dafvfrh6mx26hpssxj";
  };
  circle = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/filled/circle.svg";
    sha256 = "sha256:0aq8nk95v2l2i1zc8556smyvih0n348yp8f2ws5mxqv2wnrsqyhv";
  };
  circleOutline = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/outlined/circle.svg";
    sha256 = "sha256:1b6z9sk0w9dvd3dpbylcqfhb66pj5k71gyj525mwcvgqhnnldl6n";
  };
  logout = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/outlined/logout.svg";
    sha256 = "sha256:0brmqc18b2c5nnch3ll5darjcr09zpr4f583yryaf1nlf0yxlafw";
  };
  networkspeed = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/outlined/swap_vert.svg";
    sha256 = "sha256:1nn9rzrlnj8ls41i9y760m6hlppby57ga9iis739ikyx7rnmyjy0";
  };
  randomaccessmemory = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@mdi/svg@7.4.47/svg/raspberry-pi.svg";
    sha256 = "sha256:05nynwgqqmhg4x8bc8fhlm7nn8vymsfdv82bxfnsy2bqd6ffqgri";
  };
  restart = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/outlined/restart_alt.svg";
    sha256 = "sha256:0lfvpsrf4d40l5gn3mh8z4x97yxq5r6c4axl7m07lqywlisrs369";
  };
  shutdown = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@material-design-icons/svg@0.14.15/outlined/power_settings_new.svg";
    sha256 = "sha256:1dn7n31kdmlj5773j2746b2lpb6xv2pysyv14yhvlfq269b2jrsp";
  };

  agsConfigFile = pkgs.stdenv.mkDerivation {
    name = "icons";

    src = ./ags;

    nativeBuildInputs = [ pkgs.ffmpeg ];

    buildPhase = ''
      ffmpeg -hide_banner -v warning -i ${bongocat} -filter_complex "[0:v] scale=32:-1:flags=lanczos,split [a][b]; [a] palettegen=reserve_transparent=on:transparency_color=ffffff [p]; [b][p] paletteuse" bongocat-32.gif
    '';

    installPhase = ''
      mkdir --parents $out/icons $out/gifs
      cp -r * $out/
      cp ${circle} $out/icons/circle-symbolic.svg
      cp ${circleOutline} $out/icons/circle-outline-symbolic.svg
      cp ${logout} $out/icons/logout-symbolic.svg
      cp ${networkspeed} $out/icons/networkspeed-symbolic.svg
      cp ${randomaccessmemory} $out/icons/randomaccessmemory-symbolic.svg
      cp ${restart} $out/icons/restart-symbolic.svg
      cp ${shutdown} $out/icons/shutdown-symbolic.svg
      cp bongocat-32.gif $out/gifs
    '';
  };
in
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

  xdg.configFile."ags" = {
    source = agsConfigFile;
    force = true;
  };
}
