{
  programs.emacs.enable = true;
  services.emacs.enable = true;

  # Doom specific requirements
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  xdg.configFile."doom" = {
    source = ./doom;
  };
}
