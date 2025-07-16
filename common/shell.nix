{ pkgs, inputs, ... }:
{
  environment.shells = with pkgs; [
    bashInteractive
    fish
  ];

  environment.systemPackages = with pkgs; [
    colmena
    dive
    dnsutils
    fd
    htop
    killall
    podman-compose
    podman-tui
    ripgrep
    unison
    unzip
    wget
  ];

  programs = {
    fish.enable = true;
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
