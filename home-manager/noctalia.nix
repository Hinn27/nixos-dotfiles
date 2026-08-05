# Noctalia Shell Configuration Module
{ config, pkgs, ... }:

{
  # Symlink entire noctalia configuration directory to ~/.config/noctalia
  xdg.configFile."noctalia".source = ./noctalia;
}
