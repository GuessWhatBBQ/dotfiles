{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      local config = wezterm.config_builder()

      config.scrollback_lines = 100000

      config.font = wezterm.font_with_fallback {
        'FiraMono Nerd Font Mono',
        'DejaVu Sans Mono',
        'Symbols Nerd Font',
      }
      config.font_size = 14
      config.line_height = 1

      config.freetype_load_flags = 'FORCE_AUTOHINT'
      config.freetype_load_target = 'Light'
      config.allow_square_glyphs_to_overflow_width = 'Never'
      config.warn_about_missing_glyphs = false

      config.default_cursor_style = "BlinkingBar"
      config.cursor_blink_ease_in = "Ease"
      config.cursor_blink_ease_out = "Linear"
      config.cursor_blink_rate = 400

      config.enable_tab_bar = false
      config.window_decorations = 'NONE'
      config.window_background_opacity = 0.8

      config.colors = {
        foreground = "#0abdc6",
        background = "#000b1e",

        selection_fg = "#000b1e",
        selection_bg = "#0abdc6",

        quick_select_match_fg = { Color = '#000b1e' },
        quick_select_match_bg = { Color = '#0abdc6' },

        copy_mode_inactive_highlight_bg = { AnsiColor = 'Yellow' },

        cursor_bg = "#0abdc6",
        cursor_border = "#0abdc6",

        ansi = {
          "#123e7c", -- color0
          "#ff0000", -- color1
          "#d300c4", -- color2
          "#f57800", -- color3
          "#123e7c", -- color4
          "#711c91", -- color5
          "#0abdc6", -- color6
          "#d7d7d5", -- color7
        },
        brights = {
          "#1c61c2", -- color8
          "#ff0000", -- color9
          "#d300c4", -- color10
          "#f57800", -- color11
          "#00ff00", -- color12
          "#711c91", -- color13
          "#0abdc6", -- color14
          "#d7d7d5", -- color15
        },
      }

      return config
    '';
  };
}
