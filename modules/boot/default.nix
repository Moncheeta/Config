{ ... }:

{
  imports = [
    ./bootloader.nix
    ./kernal.nix
    ./drives.nix
  ];

  boot.cleanTmpDir = true;

  services.power-profiles-daemon.enable = false;
}
