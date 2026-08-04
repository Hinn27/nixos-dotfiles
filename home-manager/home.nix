# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./kitty.nix
    ./zsh.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "hinne";
    homeDirectory = "/home/hinne";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Shell + Terminal (Managed via native modules in zsh.nix and kitty.nix)
    # kitty, starship, zoxide, eza are enabled in those modules
    neovim
    yazi
    fzf
    fastfetch
    pnpm

    # Font
    nerd-fonts.jetbrains-mono

    # Desktop shell, WM
    niri

    # General Apps
    vesktop
    telegram-desktop
    obs-studio
    localsend
    obsidian
    libreoffice
    onlyoffice-desktopeditors
    mpv
    upscayl

    # Text Editor + IDE
    neovim
    jetbrains-toolbox
    jetbrains.datagrip
    jetbrains.idea
    jetbrains.webstorm
    zed-editor
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";

  # Enable font discovery for home-manager fonts
  fonts.fontconfig.enable = true;
}
