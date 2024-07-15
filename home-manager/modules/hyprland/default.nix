{ pkgs, ... } : {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    # Put this here because the module internals kept complaining about empty
    # settings but I'm actually symlinking the settings using xdg.ConfigFile
    extraConfig = "# Dummy Settings";
  };

  xdg.configFile."hypr" = {
    source = ./hypr;
  };
}
