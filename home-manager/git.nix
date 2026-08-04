# Git Configuration
# Managed entirely by Home Manager (replaces ~/.gitconfig)
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # Your info
    userName = "Hinn";
    userEmail = "duc107243@donga.edu.vn";

    # Extra settings
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
