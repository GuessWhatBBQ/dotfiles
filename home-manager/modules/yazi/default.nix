{
  pkgs,
  ...
}:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f703392df78b5fba5e8f9f1ad0b1cb6d3def9736";
    sha256 = "1sgw4xnaimkh3yfsfhnl5g2959fkkjv4ilxla8m17vqz3c19hp1v";
  };
  starship-plugin = pkgs.fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "ea92cf49380466f07231c952b409831e6afd2156";
    sha256 = "095nqmxbx68f23ip2i574qiq2aw2jnb99dn2pdlylf0snvziryi6";
  };
  tokyo-night-flavor = pkgs.fetchFromGitHub {
    owner = "BennyOe";
    repo = "tokyo-night.yazi";
    rev = "8e6296f14daff24151c736ebd0b9b6cd89b02b03";
    sha256 = "039wyx3q1ws0hr9frc3lby967gl1fxyxd58b0q8y9v43sx3f22ic";
  };
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    package = pkgs.unstable.yazi;

    settings = {
      mgr = {
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
      mgr.prepend_keymap = [ ];
    };
  };
}
