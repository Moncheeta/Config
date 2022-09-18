{ ... }:

{
  boot.loader = {
    timeout = 0;

    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      configurationLimit = 3;

      # Since there is no other OS
      useOSProber = false;
    };
  };
}
