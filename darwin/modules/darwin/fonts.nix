{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    cascadia-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # Maple Mono NF (Ligature unhinted)
    maple-mono.NF-unhinted
    # Maple Mono NF CN (Ligature unhinted)
    maple-mono.NF-CN-unhinted
  ];
}