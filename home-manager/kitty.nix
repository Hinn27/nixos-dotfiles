# Kitty Terminal Configuration
# This module configures the Kitty terminal emulator natively using Home Manager.
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # Font configuration
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14.0;
    };

    # Theme (Managed by Noctalia Matugen)
    extraConfig = ''
      include /home/hinne/.config/kitty/themes/noctalia.conf
    '';

    # Keybindings (from your kitty.conf)
    keybindings = {
      # Phím tắt chia cửa sổ dọc/ngang
      "ctrl+b>v" = "launch --location=vsplit";
      "ctrl+b>h" = "launch --location=hsplit";

      # Di chuyển giữa các cửa sổ bằng Ctrl + các phím mũi tên
      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";

      # Plugin search.py
      "ctrl+f" = "launch --location=vsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
    };

    # Extra settings
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";

      # Window decoration
      background_opacity = "1.0";
      background_blur = "1";
      window_padding_width = "10";
      window_padding_height = "10";
      hide_window_decorations = "yes";

      # Cursor settings
      cursor_shape = "beam";
      cursor_blink_interval = "0";
      cursor_trail = "3";
      cursor_trail_stack_size = "8";

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Scrollback
      scrollback_lines = "10000";

      # Enable config reload via `kitty @ reload-config`
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      # Bell
      enable_audio_bell = "no";

      # Window splitting settings
      enabled_layouts = "splits,stack";
    };
  };
}
