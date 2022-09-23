{ ... }:

{
  imports = [
    ./displayManager.nix
  ];

  # For Wayland
  xdg.portal.wlr.enable = true;
}
