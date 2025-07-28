{ pkgs, ... }:
{
  environment.shells = with pkgs; [ zsh ];
  environment.variables = {
    # Since libvirtd is configured by nix to start qemu as root by default, virsh
    # should use the system mode daemon connection string by default as well
    # https://libvirt.org/uri.html#qemu-qemu-and-kvm-uris
    # https://www.libvirt.org/manpages/virsh.html#environment
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
}
