{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    guesswhatbbq = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
