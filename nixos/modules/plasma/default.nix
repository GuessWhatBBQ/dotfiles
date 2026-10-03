{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.desktopManager.plasma6.enable = true;

  # Enable KWallet
  security.pam.services.sddm.enableKwallet = true;
}
