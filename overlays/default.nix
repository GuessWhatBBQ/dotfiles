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
  };
}
