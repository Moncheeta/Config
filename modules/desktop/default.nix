{ ... }:

{
  imports = [
    ./displayManager.nix
    ./windowManagers
  ];

  # For Wayland
  xdg.portal.wlr.enable = true;
}
