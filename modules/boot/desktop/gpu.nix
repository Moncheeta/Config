{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  boot.kernelParams = [ "nvidia-drm.modeset=1" ]; # for wayland
}
