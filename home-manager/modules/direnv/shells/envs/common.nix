{ pkgs, llm-agents-pkgs, ... }:
pkgs.mkShell {
  name = "common-shell";
  packages = with pkgs; [
    # Numtide LLM Agents
    llm-agents-pkgs.claude-code
    llm-agents-pkgs.claudebox

    # Claude tools (from nixpkgs)
    claude-monitor

    # Markdown preview for doomemacs
    # pandoc
  ];
}
