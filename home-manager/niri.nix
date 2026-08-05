# Niri Compositor Configuration Module
{ config, pkgs, ... }:

{
  # Ensure Niri package is available
  home.packages = with pkgs; [
    niri
  ];

  # Symlink entire niri folder to ~/.config/niri
  xdg.configFile."niri".source = ./niri;
}
