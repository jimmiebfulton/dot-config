{ config, pkgs, inputs, ... }:

{
  # Host-specific configuration for Jimmie-Macbook16
  # Currently no host-specific settings, but this provides a place for them
  
  # Example host-specific settings that could be added:
  # - Hardware-specific optimizations
  # - Display scaling settings
  # - Performance profiles
  # - Host-specific environment variables
  
  imports = [
    ../configuration.nix
  ];
}