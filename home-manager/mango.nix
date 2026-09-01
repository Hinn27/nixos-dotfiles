# MangoWM Configuration Module
{
  config,
  pkgs,
  ...
}: {
  # Symlink mango config folder to ~/.config/mango
  xdg.configFile."mango".source = ./mango;
}
