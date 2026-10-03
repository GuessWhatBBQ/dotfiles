{
  inputs,
  ...
}:
let
  opacity = 0.7;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true; # started from Hyprland via uwsm

    settings = {
      shell = {
        corner_radius_scale = 1.25;
        launch_apps_as_systemd_services = true;

        panel = {
          borders = false;
          transparency_mode = "soft";
          clipboard_placement = "attached";
          open_near_click_clipboard = true;
          open_near_click_session = true;
        };

        session.show_shortcuts = false;
      };

      theme.builtin = "Catppuccin";

      wallpaper.enabled = false;

      bar.main = {
        position = "bottom";
        thickness = 40;
        scale = 0.9;
        margin_ends = 10;
        margin_edge = 10;
        radius = 20;
        widget_spacing = 12;
        shadow = false;
        background_opacity = opacity;
        reserve_space = false;
        smart_auto_hide = true;
        show_on_workspace_switch = false;

        capsule = true;
        capsule_opacity = opacity;
        capsule_thickness = 0.6;

        start = [
          "workspaces"
          "media"
        ];
        center = [ "active_window" ];
        end = [
          "tray"
          "clock"
          "network"
          "bluetooth"
          "volume"
          "battery"
          "session"
        ];
        dead_zone.actions = {
          left = "panel-toggle control-center home";
          right = "none";
        };
      };

      widget = {
        workspaces = {
          show_labels = false;
          active_pill_size = 1.6;
        };
        active_window = {
          title_scroll = "on_hover";
        };
        clock = {
          format = "{:%I:%M:%S %p}";
          tooltip_format = "{:%A, %B %d, %Y}";
        };
        media = {
          art_size = 20;
          rotate_album_art = true;
          show_progress = true;
          title_scroll = "on_hover";
        };
        bluetooth.show_label = true;
        tray.drawer = true;
      };

      dock = {
        enabled = true;
        position = "left";
        auto_hide = true;
        reserve_space = false;
        background_opacity = opacity;
        main_axis_padding = 10;
        cross_axis_padding = 4;
        item_spacing = 0;
        magnification_scale = 1.25;
        show_dots = true;
      };

      hot_corners = {
        enabled = true;
        top_left.action = "window_switcher";
      };

      control_center = {
        calendar.show_events_card = false;
        shortcuts = map (type: { inherit type; }) [
          "wifi"
          "bluetooth"
          "caffeine"
          "notification"
          "clipboard"
          "power_profile"
        ];
      };

      desktop_widgets.widget.desktop-widget-0000000000000001 = {
        type = "audio_visualizer";
        output = "HDMI-A-1";
        box_width = 1920;
        box_height = 176;
        cx = 960;
        cy = 992;
        settings = {
          background = false;
          bands = 128;
          centered = false;
          show_when_idle = false;
          color_1 = "secondary";
          color_2 = "secondary";
        };
      };

      notification.background_opacity = opacity;

      osd = {
        orientation = "vertical";
        position = "center_right"; # text popups
        position_vertical = "center_right"; # volume/brightness sliders
        background_opacity = opacity;
      };

      audio.enable_sounds = false;
      brightness.enable_ddcutil = true;

      idle = {
        pre_action_fade_seconds = 0;
        behavior.lock = {
          action = "lock";
          timeout = 1800;
        };
      };

      location.auto_locate = true;
    };
  };
}
