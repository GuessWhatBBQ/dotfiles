{
  # Enables support for Bluetooth
  hardware.bluetooth.enable = true;
  # Powers up the default Bluetooth controller on boot
  hardware.bluetooth.powerOnBoot = true;

  # Enables A2DP Sink
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
}
