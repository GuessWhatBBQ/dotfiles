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

        local devdir="$HOME/.local/share/dev"

        # ~/.local/share/dev is a home-manager symlink into the nix store, and
        # every file in the store gets its mtime pinned to a fixed epoch value.
        # nix-direnv's cache-staleness check is a plain mtime comparison, so a
        # `nix flake update` there never looks "newer" and the cache never
        # invalidates on its own. Track which store path we last built against
        # and blow away .direnv ourselves when home-manager has moved it.
        local target
        target=$(readlink -f "$devdir" 2>/dev/null)
        local layout_dir
        layout_dir=$(direnv_layout_dir)
        local marker="$layout_dir/dev-target"
        if [[ -f "$marker" && "$(cat "$marker" 2>/dev/null)" != "$target" ]]; then
          rm -rf "$layout_dir"
        fi

        use flake "$devdir#$name"

        mkdir -p "$layout_dir"
        echo "$target" > "$marker"
      }
    '';
  };

  home.file.".local/share/dev".source = ./shells;
}
