{ ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      # `common` is always loaded, whether or not it is listed
      use_dev() {
        local env envs=(common)
        for env in "$@"; do
          if [[ "$env" != common ]]; then
            envs+=("$env")
          fi
        done

        for env in "''${envs[@]}"; do
          use flake "$HOME/.local/share/dev#$env"
        done
      }
    '';
  };

  home.file.".local/share/dev".source = ./shells;
}
