{ ... }:

{
  imports = [
    ./hardware.nix
    ./bootloader.nix
    ./kernal.nix
  ];

  boot.cleanTmpDir = true;
}
