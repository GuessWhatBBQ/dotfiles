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
    initExtra = ''
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
