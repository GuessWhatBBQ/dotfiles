{
  lib,
  fetchFromGitHub,
  cmake,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin (finalAttrs: {
  # The pluginName must be the same name as the lib*.so file that the repo's makefile will
  # compile the plugin code to, libhyprhook.so in this case.
  # Note: It is case sensitive.
  # This could also potentially be done like this
  # https://discourse.nixos.org/t/help-adding-plugins-for-hyprland/44945/14
  pluginName = "hyprhook";
  version = "master-06e206b";

  src = fetchFromGitHub {
    owner = "Hyprhook";
    repo = "Hyprhook";
    rev = "06e206b0e426427d47c02466eb63a613ff4b4c64";
    hash = "sha256-EIIay9upB4Ntk80A0pfCau8DfKixeWqptnWAVQtMGwg=";
  };

  sourceRoot = "${finalAttrs.src.name}/hyprhook";

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
})
