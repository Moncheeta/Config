{ hyprland, ... }:

{
  imports=[
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig=''
      source=$CONFIG_DIR/Custom/Desktop/hyprland.conf
    '';
  };
}
