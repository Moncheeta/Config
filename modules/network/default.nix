{ lib, ... }:

{
  networking = {
    hostName = "moncheeta";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true
  };
}
