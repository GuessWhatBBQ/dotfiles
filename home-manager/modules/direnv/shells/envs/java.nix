{ pkgs, ... }:
let
  jdk = pkgs.jdk17;

  mavenArgs = pkgs.lib.functionArgs pkgs.maven.override;
  maven =
    if builtins.hasAttr "jdk" mavenArgs then
      pkgs.maven.override { inherit jdk; }
    else
      pkgs.maven.override { jdk_headless = jdk; };
in
pkgs.mkShell {
  name = "java-shell";
  packages = [
    jdk
    maven
    (pkgs.gradle.override { java = jdk; })
    pkgs.jdt-language-server
  ];

  shellHook = ''
    export JAVA_HOME="${jdk.home}"
  '';
}
