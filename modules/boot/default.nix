{ config, ... }:

{
  imports = [
    ./hardware.nix
    ./kernal.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
    configurationLimit = 3;
  };

  boot.cleanTmpDir = true;
}
