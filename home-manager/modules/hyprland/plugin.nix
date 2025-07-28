{
  lib,
  fetchFromGitHub,
  cmake,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin hyprland rec {
  # The pluginName must be the same name as the lib*.so file that the repo's makefile will
  # compile the plugin code to, libhyprhook.so in this case.
  # Note: It is case sensitive.
  # This could also potentially be done like this
  # https://discourse.nixos.org/t/help-adding-plugins-for-hyprland/44945/14
  pluginName = "hyprhook";
  version = "0.1-8815354";

  src = fetchFromGitHub {
    owner = "Hyprhook";
    repo = "Hyprhook";
    rev = "e564bf0fa6467650e4de0c2609705b097ef26da3";
    hash = "sha256-N+9GdAX99CeFC4RYt1NF8UTYgPeKTrtn5Vs3+08aSJM=";
  };

  sourceRoot = "${src.name}/hyprhook";

  # any nativeBuildInputs required for the plugin
  nativeBuildInputs = [ cmake ];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [ ];

  meta = {
    homepage = "https://github.com/Hyprhook/Hyprhook";
    description = "A plugin for Hyprland that can call a script when an event occurs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
