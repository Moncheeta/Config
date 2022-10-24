{ lib, ... }:

{
  networking = {
    hostName = "moncheeta";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
