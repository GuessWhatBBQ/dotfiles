{
  description = "Dev shells, one per language/tool (see ./envs)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { nixpkgs, llm-agents, ... }:
    let
      inherit (nixpkgs) lib;

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      llm-agents-pkgs = llm-agents.packages.${system};

      # Every ./envs/<name>.nix is one building block.
      envNames = lib.pipe (builtins.readDir ./envs) [
        (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name))
        builtins.attrNames
        (map (lib.removeSuffix ".nix"))
      ];

      envs = lib.genAttrs envNames (name: import ./envs/${name}.nix { inherit pkgs llm-agents-pkgs; });

      # Every non-empty combination of envs, in sorted order (attrNames sorts).
      combos = lib.foldl' (acc: name: acc ++ map (combo: combo ++ [ name ]) acc) [ [ ] ] (
        lib.remove "common" envNames
      );

      # `use_dev` (see ../default.nix) asks for a single shell, e.g. "node+python",
      # so nix-direnv keeps one cache entry instead of one per env, which it would
      # wipe on every reload. Attrsets are lazy: only the requested combo is evaluated.
      #
      # `common` is always included; shellHooks run in the order listed.
      mkCombo =
        combo:
        pkgs.mkShell {
          name = "${lib.concatStringsSep "+" combo}-shell";
          inputsFrom = lib.reverseList (map (name: envs.${name}) ([ "common" ] ++ combo));
        };
    in
    {
      devShells.${system} =
        envs
        // lib.listToAttrs (
          map (combo: lib.nameValuePair (lib.concatStringsSep "+" combo) (mkCombo combo)) (
            lib.filter (combo: combo != [ ]) combos
          )
        );
    };
}
