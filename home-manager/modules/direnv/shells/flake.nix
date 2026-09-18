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

      # Every ./envs/<name>.nix becomes devShells.<name>.
      shellNames = lib.pipe (builtins.readDir ./envs) [
        (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name))
        builtins.attrNames
        (map (lib.removeSuffix ".nix"))
      ];
    in
    {
      devShells.${system} = lib.genAttrs shellNames (
        name: import ./envs/${name}.nix { inherit pkgs llm-agents-pkgs; }
      );
    };
}
