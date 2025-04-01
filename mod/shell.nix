{ pkgs, ... }:
{
  environment.shells = with pkgs; [
    bashInteractive
    fish
  ];

  environment.systemPackages = with pkgs; [
    bc
    docker-compose
    fd
    gh
    gnumake
    htop
    killall
    ripgrep
    starship
    stow
    unzip
    wget
    wl-clipboard
  ];

  programs = {
    fish.enable = true;
    git.enable = true;
    tmux = {
      enable = true;
      clock24 = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  # --- Excludes ---
  programs.nano.enable = false;

  # Enabled by fish but takes soooo long.
  # This is apparently used by some of fish's
  # autocomplete features.
  documentation.man.generateCaches = false;

  # To stop the annoying error on entering wrong commands
  programs.command-not-found.enable = false;
}
