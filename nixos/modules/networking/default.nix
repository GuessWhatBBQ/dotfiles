{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      51923 # miniserve
    ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
}
