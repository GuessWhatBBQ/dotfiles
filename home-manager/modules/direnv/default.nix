{ ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_dev() {
        local env
        for env in "$@"; do
          use flake "$HOME/.local/share/dev/''$env"
        done
      }
    '';
  };

  home.file.".local/share/dev".source = ./shells;
}
