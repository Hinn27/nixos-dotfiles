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
    ./starship.nix
    ./git.nix
    ./scripts.nix
    ./tools.nix
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

  # Environment Variables
  home.sessionVariables = {
    PNPM_HOME = "$HOME/.local/share/pnpm";
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/share/pnpm/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.local/bin"
  ];

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Shell + Terminal (Managed via native modules in zsh.nix, kitty.nix, tools.nix)
    neovim
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

  # Enable home-manager
  programs.home-manager.enable = true;

  # Sops-Nix configuration for secrets
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt"; # Phải trỏ đúng file chứa key
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets."ssh_key" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";

  # Enable font discovery for home-manager fonts
  fonts.fontconfig.enable = true;
}
