# Noctalia Shell Configuration Module
{ config
, pkgs
, ...
}: {
  # Use recursive to allow Noctalia GUI to save settings
  xdg.configFile."noctalia" = {
    source = ./noctalia;
    recursive = true;
  };
}
