{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3563", ATTR{power/autosuspend}="-1"
  '';
}
