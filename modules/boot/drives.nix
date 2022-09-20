{ ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
