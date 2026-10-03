{
  inputs,
  outputs,
  lib,
  config,
  ...
}:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ./modules/default.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  hardware.enableRedistributableFirmware = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.ringboard.wayland.enable = true;

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.modified-packages
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-39.8.10" ];
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable optimization by hardlinking duplicate files in the Nix store
        auto-optimise-store = true;
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;

        extra-substituters = [
          # "https://devenv.cachix.org?priority=999"
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
