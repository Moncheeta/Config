{ ... }:

{
  xdg.portal.wlr.enable = true;

  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;
}
