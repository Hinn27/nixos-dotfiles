{
  config,
  pkgs,
  ...
}: {
  # Link sway config
  xdg.configFile."sway/config".source = ./sway/config;
}
