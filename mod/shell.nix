{ pkgs, ... }:
{
  environment.shells = with pkgs; [
    fish
    bashInteractive
  ];

  environment.systemPackages = with pkgs; [
    wget
    htop
    bc
    gh
    gnumake
    killall
    stow
    docker-compose
    starship
    unzip
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
