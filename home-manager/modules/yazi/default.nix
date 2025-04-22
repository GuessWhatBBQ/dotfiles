{
  pkgs,
  ...
}:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b12a9ab085a8c2fe2b921e1547ee667b714185f9";
    sha256 = "sha256-LWN0riaUazQl3llTNNUMktG+7GLAHaG/IxNj1gFhDRE=";

  };
  starship-plugin = pkgs.fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "c0707544f1d526f704dab2da15f379ec90d613c2";
    sha256 = "sha256-H8j+9jcdcpPFXVO/XQZL3zq1l5f/WiOm4YUxAMduSRs=";
  };
  tokyo-night-flavor = pkgs.fetchFromGitHub {
    owner = "BennyOe";
    repo = "tokyo-night.yazi";
    rev = "695dac6bcc605ba4b0bf1b1f56169eaa7cc4bb40";
    sha256 = "sha256-+wZzxLPCttJ2WoDdI89sQ+CcZSFIA44HshxMoh4rJIs=";
  };
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    package = pkgs.unstable.yazi;

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      # git = "${yazi-plugins}/git.yazi";
      # vcs-files = "${yazi-plugins}/vcs-files.yazi";
      starship = starship-plugin;
    };

    flavors = {
      tokyo-night = tokyo-night-flavor;
    };

    theme = {
      flavor = {
        dark = "tokyo-night";
        light = "tokyo-night";
      };
    };

    initLua = ''
      			require("starship"):setup()
      		'';

    keymap = {
      manager.prepend_keymap = [ ];
    };
  };
}
