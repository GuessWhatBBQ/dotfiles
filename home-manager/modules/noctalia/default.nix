{
  inputs,
  ...
}:
let
  opacity = 0.7;

  # Shared capsule behind a set of bar widgets, referenced in a lane as "group:<id>"
  capsuleGroup = id: members: { inherit id members opacity; };
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
          open_near_click_control_center = true;
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
          "group:g2"
          "media"
        ];
        center = [ "group:g1" ];
        end = [
          "tray"
          "sysmon"
          "group:g4"
          "group:g3"
          "session"
        ];
        capsule_group = [
          (capsuleGroup "g1" [
            "weather"
            "clock"
          ])
          (capsuleGroup "g2" [
            "workspaces"
            "active_window"
          ])
          (capsuleGroup "g3" [
            "network"
            "bluetooth"
            "brightness"
            "battery"
          ])
          (capsuleGroup "g4" [
            "volume"
            "input_volume"
          ])
        ];
        dead_zone.actions = {
          left = "panel-toggle control-center home";
          right = "panel-toggle clipboard";
          scroll_up = "workspace-switch prev";
          scroll_down = "workspace-switch next";
        };
      };

      widget = {
        workspaces = {
          show_labels = false;
          active_pill_size = 1.6;
        };
        active_window = {
          title_scroll = "always";
          # Has no click action of its own, so match the bar's empty-space click
          actions.left = "panel-toggle control-center home";
        };
        clock = {
          format = "{:%a %d %b | %I:%M:%S %p}";
          tooltip_format = "{:%A, %B %d, %Y}";
        };
        media = {
          art_size = 20;
          rotate_album_art = true;
          show_progress = true;
          title_scroll = "always";
        };
        tray.drawer = true;

        battery.show_label = false;
        brightness.show_label = false;
        network.show_label = false;
        volume.show_label = false;
        input_volume.show_label = false;

        sysmon = {
          glyph = "heart-rate-monitor";
          highlight_color = "on_surface";
          show_value = false;
          visualization = "none";
        };
      };

      lockscreen = {
        transition = [ "zoom" ];
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

      desktop_widgets.widget.desktop-widget-0000000000000001 = {
        type = "audio_visualizer";
        output = "HDMI-A-1";
        box_width = 1920;
        box_height = 176;
        cx = 960;
        cy = 88;
        flip_y = true;
        settings = {
          background = false;
          bands = 128;
          centered = false;
          show_when_idle = false;
          color_1 = "error";
          color_2 = "error";
        };
      };

      notification.background_opacity = opacity;

      osd = {
        orientation = "vertical";
        position = "center_right";
        position_vertical = "center_right";
        background_opacity = opacity;
        hide_delay_ms = 4000;
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
