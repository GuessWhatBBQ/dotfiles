{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".SpaceVim.d" = {
    source = ./SpaceVim.d;
  };
}
