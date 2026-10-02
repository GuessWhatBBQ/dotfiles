{ pkgs, ... }:
let
  # HP Laser MFP 1188w (same engine as the HP Laser MFP 13x series).
  # Not supported by hplip, so use HP's Unified Linux Driver (unfree).
  # The smfp scanner backend only accepts USB product IDs listed in oem.conf,
  # which lacks the 1188w (03f0:079e); add it so USB scanning works. The udev rule
  # generated from oem.conf compares the IDs case-sensitively against the kernel's
  # lowercase values, so lowercase them too.
  hp-uld = pkgs.hp-unified-linux-driver.override {
    fetchurl =
      args:
      pkgs.runCommand "uld-hp-src" { } ''
        mkdir $out
        tar xzf ${pkgs.fetchurl args} -C $out --strip-components=1
        sed -i \
          -e 's/^VID=\(.*\)/VID=\L\1/' \
          -e 's/^PIDS="\(.*\)"/PIDS="\L\1 079e"/' \
          $out/noarch/oem.conf
      '';
  };
in
{
  # imports = [ ./wsd-scan.nix ];

  # Printing over USB and Wi-Fi
  services.printing = {
    enable = true;
    drivers = [ hp-uld ];
  };

  # Network printer/scanner discovery (mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanning with the ULD smfp backend
  hardware.sane = {
    enable = true;
    extraBackends = [ hp-uld ];
  };

  environment.systemPackages = [ pkgs.naps2 ];
}
