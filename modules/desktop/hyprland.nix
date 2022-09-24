{ hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = ''
      input {
        kb_variant = colemak
        follow_mouse = 0
        force_no_accel = true
        touchpad {
          natural_scroll = yes
        }
      }

      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2 
        damage_tracking = full
      }

      decoration {
        rounding = 10
        blur = 1
        blur_size = 3
        blur_passes = 1
        blur_new_optimizations = 1
      }

      dwindle {
        pseudotile = 1
      }

      gestures {
        workspace_swipe = yes
      }
      
      bindm = SUPER,mouse:272,movewindow
      bindm = SUPER,mouse:273,resizewindow
      bind = SUPER,V,togglefloating,
      bind = SUPER,P,pseudo,
      bind = SUPER,C,killactive,
      bind = SUPER,left,movefocus,l
      bind = SUPER,right,movefocus,r
      bind = SUPER,up,movefocus,u
      bind = SUPER,down,movefocus,d

      bind = SUPER,1,workspace,1
      bind = SUPER,2,workspace,2
      bind = SUPER,3,workspace,3
      bind = SUPER,4,workspace,4
      bind = SUPER,5,workspace,5
      bind = SUPER,6,workspace,6
      bind = SUPER,7,workspace,7
      bind = SUPER,8,workspace,8
      bind = SUPER,9,workspace,9
      bind = SUPER,0,workspace,0

      bind = SUPER,1,movetoworkspace,1
      bind = SUPER,2,movetoworkspace,2
      bind = SUPER,3,movetoworkspace,3
      bind = SUPER,4,movetoworkspace,4
      bind = SUPER,5,movetoworkspace,5
      bind = SUPER,6,movetoworkspace,6
      bind = SUPER,7,movetoworkspace,7
      bind = SUPER,8,movetoworkspace,8
      bind = SUPER,9,movetoworkspace,9
      bind = SUPER,0,movetoworkspace,0

      bind = SUPER,T,exec,kitty
      bind = SUPER,W,exec,qutebrowser
    '';
  };
}