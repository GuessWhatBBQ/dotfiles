# This file defines overlays
{ inputs, ... }:
{
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  modified-packages = final: prev: {
    # antigravity = prev.antigravity.overrideAttrs (oldAttrs: {
    #   version = "1.23.2";

    #   src = prev.fetchurl {
    #     url = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/1.23.2-4781536860569600/linux-x64/Antigravity.tar.gz";
    #     hash = "sha256-UjKkBI/0+hVoXZqYG6T7pXPil/PvybdvY455S693VyU=";
    #   };
    #   buildInputs =
    #     (oldAttrs.buildInputs or [ ])
    #     ++ (with prev; [
    #       curl
    #       openssl
    #       webkitgtk_4_1
    #       libsoup_3
    #     ]);
    # });

    logseq =
      let
        pname = "logseq";
        version = "0.10.15";
        src = prev.fetchurl {
          url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x64-${version}.AppImage";
          hash = "sha256-i5EQUvSW1ix+8NT8nCs6mGH2B9xF7G4mB7vBhDJ7JdE=";
        };
        appimageContents = prev.appimageTools.extractType2 {
          inherit pname version src;
        };
      in
      prev.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/Logseq.desktop $out/share/applications/logseq.desktop

          # 1. Inject Wayland flags
          # 2. Hardcode the absolute Nix store path directly to the Papirus icon!
          substituteInPlace $out/share/applications/logseq.desktop \
            --replace-quiet 'Exec=Logseq %u' 'Exec=logseq --enable-features=UseOzonePlatform --ozone-platform=wayland %u' \
            --replace-quiet 'Icon=Logseq' 'Icon=${prev.papirus-icon-theme}/share/icons/Papirus/64x64/apps/logseq.svg'
        '';
      };
  };
}
