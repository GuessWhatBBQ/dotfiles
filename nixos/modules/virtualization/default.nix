{ pkgs, ... }:
{
  # virtualisation.vmware.host.enable = true;
  virtualisation.vmware.host.package = pkgs.unstable.vmware-workstation;
  boot.kernelParams = [ "transparent_hugepage=never" ];
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "virbr0"
    ];
  };
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings = {
      experimental = true;
      data-root = "/mnt/Data2/Docker";
    };
  };
}
