{ pkgs, ... }:
{
  programs.mpv.enable = true;

  xdg.configFile."mpv" = {
    source = ./mpv/mpv.conf;
    target = "mpv/mpv.conf";
  };

  xdg.configFile."fastforward.lua" = {
    source =
      pkgs.fetchFromGitHub {
        owner = "jgreco";
        repo = "mpv-scripts";
        rev = "3ec6cf9f4e5a4b5737b38d1ad6aa2ac8297092a2";
        hash = "sha256-bqloLYAPx/8BiCRfZBHTm1Z+H0EZ0XSvD9SW90VkJMU=";
      }
      + /fastforward.lua;
    target = "mpv/scripts/fastforward.lua";
  };
}
