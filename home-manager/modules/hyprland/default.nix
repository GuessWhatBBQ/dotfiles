{ pkgs, lib, ... }:
let

  # Absolutely brilliant artwork by aconfuseddragon (https://aconfuseddragon.neocities.org)
  autumnfeels = builtins.fetchurl {
    url = "https://aconfuseddragon.neocities.org/art/autumn-feels.gif";
    sha256 = "sha256:0hs927hizwh79gs6cwpjzfx9zcykj4sdahfv0bhir99gr8c6n2qv";
  };
  keypress = ./keypresseventprocessor.bash;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    plugins = [
      (pkgs.callPackage ./plugin.nix { })
    ];

    # Put this here because the module internals kept complaining about empty
    # settings but I'm actually symlinking the settings using xdg.ConfigFile
    extraConfig = "# Dummy Settings";
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
    exec-once = ${pkgs.swww}/bin/swww-daemon && ${pkgs.swww}/bin/swww img ${autumnfeels} &
    ${builtins.readFile hypr/hyprland.conf}
    exec-once = touch /tmp/keypressevent &
    plugin {
      hyprhook {
        keyPress = ${keypress}
      }
    }
    exec-once = ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &
    exec-once = ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init &
  '';
}
