{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
      cache = true;
      demuxer-max-bytes = "8192M";
      demuxer-max-back-bytes = "1024M";
      volume-max = 200;
      pulse-latency-hacks = true;
      input-ipc-server = "/tmp/mpvsocket";

      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";

      af = "format=channels=stereo,acompressor=threshold=-22dB:ratio=8:makeup=4";
    };
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
