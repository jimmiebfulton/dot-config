{ config, pkgs, inputs, ... }:

{
  # Import the modular darwin configuration
  imports = [
    ./modules/darwin
  ];
}
