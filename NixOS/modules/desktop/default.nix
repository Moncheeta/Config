{ ... }:

{
  imports = [
    ./fonts.nix
  ];
  # For Wayland
  xdg.portal.wlr.enable = true;
}
