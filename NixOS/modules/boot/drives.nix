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
    "/home/moncheeta/Storage/Other" = {
      device = "/dev/disk/by-label/Other";
      fsType = "xfs";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];
}
