{ ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "-0.5";
      };
    };
  };
}
