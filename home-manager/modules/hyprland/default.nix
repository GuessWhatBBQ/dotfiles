{ pkgs, lib, ... }:
let
  inherit (lib.generators) mkLuaInline toLua;
  lua = toLua { };

  # Absolutely brilliant artwork by aconfuseddragon (https://aconfuseddragon.neocities.org)
  # Their X account is @aconfuseddragon, check them out!
  autumnfeels = builtins.fetchurl {
    url = "https://aconfuseddragon.neocities.org/art/autumn-feels.gif";
    sha256 = "0hs927hizwh79gs6cwpjzfx9zcykj4sdahfv0bhir99gr8c6n2qv";
  };
  # keypress = ./keypresseventprocessor.bash;

  terminal = "wezterm";
  fileManager = "wezterm -e yazi";
  audiomixer = "wezterm -e pulsemixer";
  menu = "caelestia shell drawers toggle launcher";
  # Nothing here writes to disk: no --output-filename, so satty only copies to the
  # clipboard; save manually via satty's "save as" if wanted.
  satty = "satty --filename - --copy-command wl-copy --early-exit --actions-on-enter save-to-clipboard";
  screenshotArea = "grimblast --freeze save area - | ${satty}";
  screenshotWindow = "grimblast save active - | ${satty}";
  screenshotOutput = "grimblast save output - | ${satty}";

  mainMod = "SUPER";
  mainModShift = "SUPER + SHIFT";
  mainModCtrl = "SUPER + CTRL";

  # hl.dsp.<fn>(<args>)
  dsp = fn: args: mkLuaInline "hl.dsp.${fn}(${lib.concatMapStringsSep ", " lua args})";
  exec = cmd: dsp "exec_cmd" [ cmd ];
  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };

  # Keys 1-9 then 0, mapped to workspaces 1-10
  workspaces = map (i: {
    key = toString (lib.mod i 10);
    id = i;
  }) (lib.range 1 10);

  windowRule = match: rule: { inherit match; } // rule;
  assignWorkspace = class: workspace: windowRule { inherit class; } { inherit workspace; };

  noBordersOn =
    workspace:
    windowRule
      {
        float = 0;
        inherit workspace;
      }
      {
        border_size = 0;
        rounding = 0;
      };
  noGapsOn = workspace: {
    inherit workspace;
    gaps_out = 0;
    gaps_in = 0;
  };

  animation =
    leaf: speed: bezier: extra:
    {
      inherit leaf speed bezier;
      enabled = true;
    }
    // extra;

  startupCommands = [
    "caelestia shell -d"
    "sleep 2; maestral_qt &"
    "${pkgs.awww}/bin/awww-daemon && ${pkgs.awww}/bin/awww img ${autumnfeels} &"
    "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &"
    "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init &"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;
    systemd.enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    # plugins = [
    #   (pkgs.callPackage ./plugin.nix { })
    # ];

    # Each attribute becomes an hl.<name>(...) call; lists produce one call per element
    settings = {
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "1920x1080@165";
          position = "auto";
          scale = "1";
          cm = "hdr";
          sdrbrightness = 1.4;
          sdrsaturation = 1.0;
        }
        {
          output = "eDP-1";
          mode = "1920x1080@144";
          position = "auto";
          scale = "1";
          bitdepth = 10;
          sdrsaturation = 1.4;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "1";
        }
      ];

      env =
        lib.mapAttrsToList
          (name: value: {
            _args = [
              name
              value
            ];
          })
          {
            XCURSOR_SIZE = "24";
            XCURSOR_THEME = "Bibata-Modern-Classic";
            HYPRCURSOR_SIZE = "24";
            HYPRCURSOR_THEME = "Bibata-Modern-Classic";
          };

      curve = {
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      };

      animation = [
        (animation "windows" 7 "myBezier" { })
        (animation "windowsOut" 7 "default" { style = "popin 80%"; })
        (animation "border" 10 "default" { })
        (animation "borderangle" 8 "default" { })
        (animation "fade" 7 "default" { })
        (animation "workspaces" 6 "default" { })
      ];

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        (bind "${mainMod} + return" (exec terminal))
        (bind "${mainMod} + m" (exec audiomixer))
        (bind "${mainModShift} + return" (exec fileManager))
        (bind "${mainMod} + d" (exec menu))
        (bind "Print" (exec screenshotArea))
        (bind "SHIFT + Print" (exec screenshotWindow))
        (bind "${mainModShift} + Print" (exec screenshotOutput))

        (bind "${mainMod} + grave" (dsp "window.close" [ ]))
        (bind "${mainModShift} + space" (dsp "window.float" [ { action = "toggle"; } ]))
        (bind "${mainMod} + P" (dsp "window.pseudo" [ ]))
        (bind "${mainMod} + v" (dsp "layout" [ "togglesplit" ]))

        (bind "${mainMod} + h" (dsp "focus" [ { direction = "left"; } ]))
        (bind "${mainMod} + l" (dsp "focus" [ { direction = "right"; } ]))
        (bind "${mainMod} + k" (dsp "focus" [ { direction = "up"; } ]))
        (bind "${mainMod} + j" (dsp "focus" [ { direction = "down"; } ]))

        (bind "${mainMod} + f" (
          dsp "window.fullscreen" [
            {
              mode = "fullscreen";
              action = "toggle";
            }
          ]
        ))
      ]
      ++ map (ws: bind "${mainMod} + ${ws.key}" (dsp "focus" [ { workspace = ws.id; } ])) workspaces
      ++ map (
        ws: bind "${mainModCtrl} + ${ws.key}" (dsp "focus" [ { workspace = ws.id + 10; } ])
      ) workspaces
      ++ map (
        ws: bind "${mainModShift} + ${ws.key}" (dsp "window.move" [ { workspace = ws.id; } ])
      ) workspaces
      ++ [
        (bind "${mainMod} + S" (dsp "workspace.toggle_special" [ "magic" ]))
        (bind "${mainModShift} + S" (dsp "window.move" [ { workspace = "special:magic"; } ]))

        (bind "${mainMod} + mouse_down" (dsp "focus" [ { workspace = "e+1"; } ]))
        (bind "${mainMod} + mouse_up" (dsp "focus" [ { workspace = "e-1"; } ]))

        (bind "${mainMod} + mouse:272" (dsp "window.drag" [ ]))
        (bind "${mainMod} + mouse:273" (dsp "window.resize" [ ]))

        (bind "${mainModShift} + colon" (exec "dunstctl set-paused toggle"))
        (bind "${mainMod} + semicolon" (exec "dunstctl history-pop"))
        (bind "${mainMod} + apostrophe" (exec "dunstctl close"))
        (bind "${mainMod} + quotedbl" (exec "dunstctl close-all"))
      ];

      window_rule = [
        (windowRule { class = ".*"; } { suppress_event = "maximize"; })
        (windowRule { class = "(Rofi)"; } { float = true; })
        (windowRule { class = "com.gabm.satty"; } {
          float = true;
          center = true;
        })

        (assignWorkspace "(firefox)" "3")
        (assignWorkspace "(atom|Atom)" "4")
        (assignWorkspace "(emacs|Emacs)" "4")
        (assignWorkspace "(jetbrains-idea)" "4")
        (assignWorkspace "(Spotify|spotify)" "5")
        (assignWorkspace "(discord)" "6")
        (assignWorkspace "(Skype)" "9")
        (assignWorkspace "(Logseq)" "10")
        (windowRule { title = "(^qBittorrent v.*)"; } { workspace = "19"; })
        (assignWorkspace "(zoom)" "10")
        (assignWorkspace "(VirtualBox Machine)" "20")

        # Smart gaps
        (noBordersOn "w[tv1]")
        (noBordersOn "f[1]")
      ];

      workspace_rule = [
        (noGapsOn "w[tv1]")
        (noGapsOn "f[1]")
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 0;
          col = {
            active_border = {
              colors = [
                "rgba(33ccffee)"
                "rgba(00ff99ee)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;
          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;

        master.new_status = "master";

        misc = {
          force_default_wallpaper = 1;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "ctrl:nocaps";
          kb_rules = "";
          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          scroll_factor = 2;
          touchpad.natural_scroll = true;
        };
      };

      on = {
        _args = [
          "hyprland.start"
          (mkLuaInline ''
            function()
            ${lib.concatMapStringsSep "\n" (cmd: "  hl.exec_cmd(${lua cmd})") startupCommands}
            end'')
        ];
      };
    };
  };
}
