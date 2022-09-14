{ ... }:

{
  imports = [
    ./displayManager.nix
    ./kde
    ./openbox
  ];

  # For Wayland
  xdg.portal.wlr.enable = true;
}
