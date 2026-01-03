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
    name = "ags-config";

    src = ./ags;

    nativeBuildInputs = [ pkgs.ffmpeg ];

    buildPhase = ''
      ffmpeg -hide_banner -v warning -i ${bongocat} -filter_complex "[0:v] scale=32:-1:flags=lanczos,split [a][b]; [a] palettegen=reserve_transparent=on:transparency_color=ffffff [p]; [b][p] paletteuse" bongocat-32.gif
    '';

    installPhase = ''
      mkdir --parents $out/icons/hicolor/scalable/apps $out/gifs
      cp -r * $out/
      cp ${circle} $out/icons/hicolor/scalable/apps/circle-symbolic.svg
      cp ${circleOutline} $out/icons/hicolor/scalable/apps/circle-outline-symbolic.svg
      cp ${logout} $out/icons/hicolor/scalable/apps/logout-symbolic.svg
      cp ${networkspeed} $out/icons/hicolor/scalable/apps/networkspeed-symbolic.svg
      cp ${randomaccessmemory} $out/icons/hicolor/scalable/apps/randomaccessmemory-symbolic.svg
      cp ${restart} $out/icons/hicolor/scalable/apps/restart-symbolic.svg
      cp ${shutdown} $out/icons/hicolor/scalable/apps/shutdown-symbolic.svg
      cp bongocat-32.gif $out/gifs
    '';
  };
in
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = null;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.apps
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.bluetooth
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.mpris
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.network
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.notifd
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.tray
      inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.wireplumber
      libadwaita
    ];
  };

  xdg.configFile."ags" = {
    source = agsConfigFile;
    force = true;
  };
}
