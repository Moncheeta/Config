{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # For Wayland
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
}
