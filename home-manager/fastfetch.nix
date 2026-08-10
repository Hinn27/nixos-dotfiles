{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " │ ";
      };
      modules = [
        {
          type = "custom";
          format = "╭─────────────╮";
        }
        {
          type = "os";
          key = "  OS       ";
        }
        {
          type = "kernel";
          key = "  Kernel   ";
        }
        {
          type = "shell";
          key = "  Shell    ";
        }
        {
          type = "terminal";
          key = "  Terminal ";
        }
        {
          type = "wm";
          key = "  WM       ";
        }
        {
          type = "cpu";
          key = "  CPU      ";
        }
        {
          type = "gpu";
          key = " 󰢮 GPU      ";
        }
        {
          type = "memory";
          key = "  Memory   ";
        }
        {
          type = "uptime";
          key = " 󰅐 Uptime   ";
        }
        {
          type = "custom";
          format = "╰─────────────╯";
        }
      ];
    };
  };
}
