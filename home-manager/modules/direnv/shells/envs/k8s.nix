{ pkgs, ... }:
pkgs.mkShell {
  name = "k8s-shell";
  packages = with pkgs; [
    kubectl
    k9s

    # talos linux
    talosctl
  ];
}
