# Nix Configurations

Repository structure:

- **host/**  
  One subdirectory per NixOS host, each containing its host-specific configuration.

- **mod/**  
  NixOS modules.  
  - **mod/common/**: Modules enabled by default on all hosts.  
  - **mod/desktop/**: Modules enabled on desktop hosts (i.e. hosts with `hd.desktop.enable = true`).

- **home/**  
  Home Manager modules. Home Manager is integrated into the system configuration via the `home` option defined in `mod/desktop/default.nix`.

- **bin/**  
  Helper scripts for generating parts of the configuration.

- **dotfiles/**  
  Raw configuration files deployed using Home Manager.

- **devshells/**  
  Nix development shells.

- **pki/**  
  Certificates used by the configuration.

- **secrets/**  
  Age-encrypted secrets managed and deployed via agenix.

- **var/**  
  Shared constants and values used across the configuration.
