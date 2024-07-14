{
  config,
  ...
} : {

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
      ll = "ls -l";
    };
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^[[A";
      searchUpKey = "^[[B";
    };
    history = {
      size = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true;
      ignoreAllDups = true;
    };
    initExtra = ''
      bindkey -e
      bindkey '^P' up-history
      bindkey '^N' down-history
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "bgnotify" "colored-man-pages" "command-not-found" "copybuffer"
        "copypath" "cp" "extract" "fzf" "git" "man" "safe-paste" "sudo"
        "vi-mode" "zoxide" "zsh-interactive-cd"
      ];
      theme = "robbyrussell";
    };
  };
}
