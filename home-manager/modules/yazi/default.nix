{
  pkgs,
  ...
}:
let
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
        max_width = 3840;
        max_height = 2160;
        image_quality = 90;
      };
    };

    plugins = { };

    flavors = {
      tokyo-night = tokyo-night-flavor;
    };

    theme = {
      flavor = {
        dark = "tokyo-night";
        light = "tokyo-night";
      };
    };

    keymap = {
      mgr.prepend_keymap = [ ];
    };
  };
}
