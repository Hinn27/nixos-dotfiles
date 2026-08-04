# Zsh and Terminal Utilities Configuration
# This module sets up Zsh, aliases, and related tools (starship, zoxide, eza).
{ config, pkgs, ... }:

{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    
    # Enable syntax highlighting and autosuggestions
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Shell aliases (from your ~/.zsh_aliases)
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../../..";
      c = "clear";
      cleanup = "~/.local/bin/cleanup-system.sh";
      grep = "grep --color=auto";
      jctl = "journalctl -p 3 -xb";
      # eza is configured below via programs.eza, but we keep your specific aliases
      la = "eza -a --color=always --group-directories-first --icons";
      ll = "eza -l --color=always --group-directories-first --icons";
      ls = "eza -al --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      mirror = "sudo cachyos-rate-mirrors";
      update = "/home/hinne/secure-update.sh";
      v = "nvim";
      dotfiles = "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      live = "pnpm dlx live-server";
    };

    # Extra configuration added to the end of ~/.zshrc
    initContent = ''
      # Iris Autocomplete
      if command -v iris >/dev/null; then
        eval "$(iris init zsh)"
      fi

      # Set shell options
      setopt HIST_FCNTL_LOCK NO_APPEND_HISTORY NO_EXTENDED_HISTORY 
      setopt NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS

      # Quick activate venv function
      va() {
          if [[ -f "venv/bin/activate" ]]; then
              source venv/bin/activate
          elif [[ -f ".venv/bin/activate" ]]; then
              source .venv/bin/activate
          else
              echo "Lỗi: Không tìm thấy môi trường ảo (venv hoặc .venv)"
          fi
      }



      # Run fastfetch on startup
      if [[ -t 1 ]] && command -v fastfetch >/dev/null; then
        fastfetch
      fi
    '';
  };



  # Zoxide (better cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ]; # alias cd="z"
  };

  # Eza (better ls)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
