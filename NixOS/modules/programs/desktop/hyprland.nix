{ hyprland, ... }:

{
  imports=[
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig=''
      source=${toString ../../../../Custom/Desktop/hyprland.conf}
    '';
  };
}