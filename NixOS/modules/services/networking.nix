{ lib, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
