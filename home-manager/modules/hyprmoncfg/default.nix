{ pkgs, ... }:
let
  benq = {
    name = "HDMI-A-1";
    make = "BNQ";
    model = "BenQ EX2710S";
    serial = "88P01426019";
  };
  laptopPanel = {
    name = "eDP-1";
    make = "Chimei Innolux Corporation";
    model = "0x1521";
  };

  disabledOutput = output: output // {
    enabled = false;
    scale = 1.0;
    x = 0;
    y = 0;
    transform = 0;
  };

  dockedProfile = {
    name = "docked";
    outputs = [
      (benq // {
        enabled = true;
        mode = "1920x1080@165.00";
        width = 1920;
        height = 1080;
        refresh = 165.0;
        x = 0;
        y = 0;
        scale = 1.0;
        vrr = 0;
        transform = 0;
        bitdepth = 10;
        cm = "hdr";
        sdr_brightness = 0.35;
        sdr_saturation = 1.0;
        sdr_min_luminance = 0.216;
        sdr_max_luminance = 417;
      })
      (disabledOutput laptopPanel)
    ];
  };

  undockedProfile = {
    name = "undocked";
    outputs = [
      (laptopPanel // {
        enabled = true;
        mode = "1920x1080@144.00";
        width = 1920;
        height = 1080;
        refresh = 144.0;
        x = 0;
        y = 0;
        scale = 1.0;
        vrr = 0;
        transform = 0;
        bitdepth = 10;
        sdr_saturation = 1.4;
      })
      (disabledOutput benq)
    ];
  };
in
{
  home.packages = [
    pkgs.unstable.modified.hyprmoncfg
  ];

  xdg.configFile = {
    "hyprmoncfg/profiles/docked.json".text = builtins.toJSON dockedProfile;
    "hyprmoncfg/profiles/undocked.json".text = builtins.toJSON undockedProfile;
  };
}
