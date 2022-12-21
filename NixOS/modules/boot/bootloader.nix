{ ... }:

{
  boot.loader = {
    timeout = 5;
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = false;
      efiSupport = true;
      devices = [ "nodev" ];
      configurationLimit = 3;
      useOSProber = true;
    };
    systemd-boot = {
      enable = true; # Gentoo is using Grub
      configurationLimit = 3;
    };
  };
}
