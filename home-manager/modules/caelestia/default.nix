{
  inputs,
  ...
}:
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    settings = {
      bar = {
        statusIcons = [
          {
            enabled = true;
            id = "lockStatus";
          }
          {
            enabled = true;
            id = "network";
          }
          {
            enabled = true;
            id = "bluetooth";
          }
          {
            enabled = true;
            id = "audio";
          }
          {
            enabled = true;
            id = "battery";
          }
        ];
        scrollActions = {
          workspaces = true;
          volume = false;
          brightness = false;
        };
        clock = {
          showDate = true;
          showIcon = false;
        };
        activeWindow = {
          compact = true;
        };
      };
      general = {
        idle = {
          timeouts = [
            {
              timeout = 1800;
              idleAction = "lock";
              respectInhibitors = true;
            }
          ];
        };
      };
      background = {
        enabled = true;
        wallpaperEnabled = false;
        visualiser = {
          enabled = true;
          autoHide = true;
          blur = true;
          rounding = 1;
          spacing = 1;
        };
      };
      dashboard = {
        showOnHover = false;
      };
      launcher = {
        useFuzzy = {
          apps = true;
        };
        enableDangerousActions = true;
      };
      osd = {
        enableMicrophone = true;
      };
      services = {
        clockFormat = "Auto";
        weatherUnits = "Celsius";
        sensorUnits = "Celsius";
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
