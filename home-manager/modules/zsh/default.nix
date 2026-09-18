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

        if [[ $# -eq 0 ]]; then
          echo "usage: mkdev <env> [env2 ...]" >&2
          echo "available: $(ls "$devroot" 2>/dev/null)" >&2
          return 1
        fi

        local env
        for env in "$@"; do
          if [[ ! -d "$devroot/$env" ]]; then
            echo "mkdev: no devshell named '$env' in $devroot" >&2
            return 1
          fi
        done

        if [[ -e .envrc ]]; then
          echo "mkdev: .envrc already exists in $(pwd)" >&2
          return 1
        fi

        { for env in "$@"; do
            echo "use dev $env"
          done
        } > .envrc

        direnv allow .
        echo "mkdev: wrote .envrc for [$*] and allowed it"
      }

      _mkdev() {
        local -a envs
        envs=(''${(f)"$(ls "$HOME/.local/share/dev" 2>/dev/null)"})
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
          rev = "0ef87bdb5847ae0df8536111f2b9888048e2e35c";
          sha256 = "sha256-6A41J5RJ2v9Zaww3714kaoYmiBu21hS3QQRVHdiafBE=";
        };
      }
    ];
  };
}
