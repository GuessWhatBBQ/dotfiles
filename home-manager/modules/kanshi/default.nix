{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        output.criteria = "eDP-1";
      }
      {
        output.criteria = "BNQ BenQ EX2710S 88P01426019";
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            mode = "1920x1080@144.00Hz";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "BNQ BenQ EX2710S 88P01426019";
            status = "enable";
            position = "0,0";
            mode = "1920x1080@165Hz";
          }
        ];
      }
    ];
  };
}
