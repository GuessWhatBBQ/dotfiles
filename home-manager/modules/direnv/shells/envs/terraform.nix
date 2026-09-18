{ pkgs, ... }:
pkgs.mkShell {
  name = "terraform-shell";
  packages = with pkgs; [
    terraform
    terraform-providers.dmacvicar_libvirt
    terraform-ls
    tfsec
  ];
}
