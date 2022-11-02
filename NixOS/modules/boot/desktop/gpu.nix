{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia.modesetting.enable = true;
  };

  boot = {
    # For Wayland
    kernelParams = [ "nvidia-drm.modeset=1" ];
    kernelModules = [ "nvidia" ];
    extraModprobeConfig = ''options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3'';
  };
}
