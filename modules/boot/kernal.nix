{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ]; # drm is for wayland
  boot.consoleLogLevel = 5;
}
