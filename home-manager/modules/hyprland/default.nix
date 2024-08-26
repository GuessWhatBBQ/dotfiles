{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    # Put this here because the module internals kept complaining about empty
    # settings but I'm actually symlinking the settings using xdg.ConfigFile
    extraConfig = "# Dummy Settings";
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
    ${builtins.readFile hypr/hyprland.conf}
    exec-once = ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &
  '';
}
