{ lib, pkgs, ... }:
let
  # Scan to WSD: the destination shown on the printer panel, saved to ~/Documents/Scans
  profiles = [
    {
      id = "pdf";
      name = "wsd-scan - pdf";
      color = "RGB24";
      resolution = 300;
      format = "jfif";
      image_format = "jpeg";
      quality = 95;
      use_pdf = true;
      target_folder = "~/Documents/Scans";
      send_email = false;
      paper_size = "A4";
      input_src = "Platen";
    }
  ];

  wsd-scan = pkgs.python3Packages.buildPythonApplication {
    pname = "wsd-scan";
    version = "0.1.0-unstable-2026-07-15";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "Tobag";
      repo = "wsd-scan";
      rev = "86b3edb2d87c0e722e6639c2645cdb23daae92e4";
      hash = "sha256-R1JT3Kha1MRiGNWiBD58PKuecXileD2l0CBmSdabpwk=";
    };

    build-system = [ pkgs.python3Packages.setuptools ];

    dependencies = with pkgs.python3Packages; [
      lxml
      requests
      python-dateutil
      pyyaml
      pillow
      img2pdf
    ];

    # Listed but never imported; the code uses the stdlib smtplib
    pythonRemoveDeps = [ "secure-smtplib" ];

    # Profiles are read from the installed package directory; replace the samples
    postInstall = ''
      dir=$out/${pkgs.python3Packages.python.sitePackages}/wsd_scan/profiles
      find $dir -name '*.yaml' ! -name mail_service.yaml -delete
      ${lib.concatMapStrings (
        p: "cp ${builtins.toFile "${p.id}.yaml" (builtins.toJSON p)} $dir/${p.id}.yaml\n"
      ) profiles}
    '';

    pythonImportsCheck = [ "wsd_scan.cli" ];

    meta = {
      description = "WSD push-scan receiver (scan to WSD from the printer panel)";
      homepage = "https://github.com/Tobag/wsd-scan";
      license = lib.licenses.gpl3Only;
      mainProgram = "wsd-scan";
    };
  };
in
{
  # The printer POSTs ScanAvailableEvent here when the destination is picked
  networking.firewall.allowedTCPPorts = [ 6666 ];

  # Scan to WSD from the printer panel. The 1188w ignores WS-Discovery probes, so find
  # it over mDNS by model at start, along with the local address it can call back.
  # Restarts every 50 min because the printer drops subscriptions after an hour and
  # wsd-scan doesn't renew them. Started on demand: systemctl --user start wsd-scan
  systemd.user.services.wsd-scan = {
    description = "WSD push-scan receiver";
    path = [
      pkgs.avahi
      pkgs.iproute2
      pkgs.gawk
    ];
    script = ''
      printer=$(avahi-browse -rpt _uscan._tcp \
        | awk -F';' '$1 == "=" && $3 == "IPv4" && /"ty=HP Laser MFP 1188w"/ { print $8; exit }')
      if [ -z "$printer" ]; then
        echo "HP Laser MFP 1188w not found via mDNS"
        exit 1
      fi
      self=$(ip -4 route get "$printer" | sed -n 's/.* src \([0-9.]*\).*/\1/p')
      mkdir -p "$HOME/Documents/Scans"
      # 8018 is the WSD port of HP's Samsung-based printers; it isn't advertised over mDNS
      exec ${lib.getExe wsd-scan} start -t "http://$printer:8018/wsd" -s "$self"
    '';
    serviceConfig = {
      Restart = "always";
      RestartSec = 30;
      RuntimeMaxSec = "50min";
      Environment = "PYTHONUNBUFFERED=1";
    };
  };
}
