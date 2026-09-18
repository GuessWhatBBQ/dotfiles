{ ... }:
{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
    stdlib = ''
      # One `use flake` call, not one per env: nix-direnv wipes every sibling
      # profile in .direnv/ whenever one is rebuilt, so several calls never cache.
      # The flake exposes each sorted combination as "a+b" (`common` is always in).
      use_dev() {
        local env
        local -a envs=()
        for env in "$@"; do
          if [[ "$env" != common ]]; then
            envs+=("$env")
          fi
        done

        local name=common
        if ((''${#envs[@]} > 0)); then
          name=$(printf '%s\n' "''${envs[@]}" | LC_ALL=C sort -u | paste -sd+)
        fi

        use flake "$HOME/.local/share/dev#$name"
      }
    '';
  };

  home.file.".local/share/dev".source = ./shells;
}
