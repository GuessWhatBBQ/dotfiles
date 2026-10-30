{ pkgs, ... }:
{
  xdg.dataFile."godot/export_templates".source =
    "${pkgs.godot-export-templates-bin}/share/godot/export_templates";
}
