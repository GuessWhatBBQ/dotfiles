{ inputs, outputs, spicetify-nix, ... } : {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs spicetify-nix; };
    users = {
      # Import your home-manager configuration
      guesswhatbbq = import ../../../home-manager/home.nix;
    };
    backupFileExtension = "backup";
  };
}
