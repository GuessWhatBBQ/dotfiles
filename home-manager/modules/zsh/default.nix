{ config, pkgs, ... }:
{

  # Plugin specific requirements
  programs.zoxide.enable = true;
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=yellow,bold,underline";
    };
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -la";
      get = "aria2c --continue=true --max-connection-per-server=16 --split=64 --max-concurrent-downloads=64 --min-split-size=2M";
      convertpdf = "libreoffice --headless --invisible --convert-to pdf";
    };
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^[[A";
      searchUpKey = "^[[B";
    };
    history = {
      save = 50000;
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true;
      ignoreAllDups = true;
    };
    initContent = ''
      bindkey -e
      bindkey '^P' up-history
      bindkey '^N' down-history

      e () {
          (
          unsetopt multios
          $@ &>! /dev/null &!
          )
      }

      rscp () {
          cpv --no-progress --info=progress2 "$@"
      }

      rsmv () {
          rscp --remove-source-files "$@"
      }

      mkdev() {
        emulate -L zsh
        local devroot="$HOME/.local/share/dev"

        local env
        for env in "$@"; do
          if [[ ! -f "$devroot/envs/$env.nix" ]]; then
            local -a names
            names=("$devroot"/envs/*.nix(N:t:r))
            echo "mkdev: no devshell named '$env' (available: ''${names[*]})" >&2
            return 1
          fi
        done

        # drop the previous environment's cache so it can't outlive the new .envrc
        rm -rf .direnv
        echo "use dev $*" > .envrc

        direnv allow .
        echo "mkdev: wrote '$(<.envrc)' to .envrc and allowed it"
      }

      _mkdev() {
        local -a envs
        envs=("$HOME"/.local/share/dev/envs/*.nix(N:t:r))
        _describe 'devshell' envs
      }
      compdef _mkdev mkdev
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify"
        "colored-man-pages"
        "copybuffer"
        "copypath"
        "cp"
        "extract"
        "fzf"
        "git"
        "man"
        "safe-paste"
        "sudo"
        "vi-mode"
        "zoxide"
        "zsh-interactive-cd"
      ];
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "zsh-hist";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-hist";
          rev = "b2e65350660bdeb20f1a3059a7540c247a21b87d";
          sha256 = "1bb4mdagzg78sfrz2j6fzzwk3sd54ccv9zkbmyarkn11fr6jwpg5";
        };
      }
    ];
  };
}
