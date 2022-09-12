{ config, ... }:

{
  imports = [
    ./hardware.nix
    ./kernal.nix
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    configurationLimit = 3;
  };

  boot.cleanTmpDir = true;
}
