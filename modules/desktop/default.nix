{ ... }:

{
  xdg.portal.wlr.enable = true;

  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.sddm.enable = true;
}
