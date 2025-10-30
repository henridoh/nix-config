{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hd.desktop.software.development;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.software.development.enable = mkEnableOption "Dev Software";

  config = mkIf cfg.enable {
    documentation.dev.enable = true;

    environment.systemPackages = with pkgs; [
      (agda.withPackages (p: [ p.standard-library ]))
      binutils
      clang
      elan
      gcc
      gdb
      gnumake
      man-pages
      man-pages-posix
      nixfmt-rfc-style
      python313
      python313Packages.mypy
      rustup
      # jetbrains.gateway
      # jetbrains.rust-rover
    ];

    home = {
      xdg.configFile = {
        "agda/libraries".text = ''
          ${pkgs.agdaPackages.standard-library}/standard-library.agda-lib
        '';
      };
      programs.emacs = {
        enable = true;
        extraPackages = epkgs: [ epkgs.agda2-mode ];
        extraConfig = builtins.readFile ../../dotfiles/emacs/init.el;
      };
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = true;
        profiles.default = {
          enableExtensionUpdateCheck = true;
          enableUpdateCheck = false;
          extensions = with pkgs.vscode-marketplace; [
            banacorn.agda-mode
            dnut.rewrap-revived
            editorconfig.editorconfig
            james-yu.latex-workshop
            jnoortheen.nix-ide
            leanprover.lean4
            ltex-plus.vscode-ltex-plus
            maximedenes.vscoq
            mkhl.direnv
            ms-python.python
            ms-toolsai.jupyter
            ocamllabs.ocaml-platform
            rust-lang.rust-analyzer
            # ms-vscode-remote.remote-ssh
          ];
          userSettings = {
            "editor.rulers" = [ 80 ];
            "editor.formatOnPaste" = false;
            "editor.formatOnSave" = false;
            "editor.formatOnType" = false;
            # https://github.com/nix-community/nix-vscode-extensions/issues/123
            "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
            "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
            "latex-workshop.latex.autoBuild.run" = "never";
          };
        };
      };
    };
  };
}
