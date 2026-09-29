{ pkgs, ... }:
{
  programs.emacs.enable = true;
  services.emacs.enable = true;

  # Doom specific requirements
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  # hunspell must be visible to the emacs daemon's own environment, not just
  # the per-project "doom" direnv shell: the daemon starts once at login with
  # the login session's $PATH, so `(spell +hunspell)` can't find it there even
  # though envrc-mode later patches exec-path inside direnv'd project buffers.
  home.packages = [
    pkgs.hunspell
    pkgs.hunspellDicts.en_US
  ];

  xdg.configFile."doom" = {
    source = ./doom;
  };
}
