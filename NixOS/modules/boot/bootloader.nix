{ ... }:

{
  boot.loader = {
    timeout = 5;

    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      configurationLimit = 3;

      useOSProber = true;

      extraConfig = ''
        insmod all_video
        insmod gfxterm
      '';
    };
  };
}
