{ hyprland, ... }:

{
  imports=[
    hyprland.homeManagerModules.default
    ./waybar.nix
  ];

  wayland.windowManager.hyprland={
    enable=true;
    systemdIntegration=true;
    extraConfig=''
      input {
        kb_variant=colemak
        follow_mouse=0
        sensitivity=-1
        force_no_accel=true
        touchpad {
          natural_scroll=yes
        }
      }

      general {
        gaps_in=5
        gaps_out=10
        border_size=2
        col.active_border = 0xffb39df3
        col.inactive_border = 0xff27f8490
        damage_tracking=full
      }

      decoration {
        rounding=10
        active_opacity=0.9
        inactive_opacity=0.8
        blur=12
        blur_size=2
        blur_passes=5
        blur_new_optimizations=1
        drop_shadow=false
      }

      dwindle {
        pseudotile=0
      }

      gestures {
        workspace_swipe=yes
      }

      misc {
        disable_hyprland_logo=true
        disable_splash_rendering=true

      }

      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow
      bind=SUPERSHIFT,V,togglefloating,
      bind=SUPERSHIFT,F,fullscreen,0
      bind=SUPERSHIFT,C,killactive,

      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d

      bind=SUPERCTRL,left,workspace,e-1
      bind=SUPERCTRL,right,workspace,e+1

      bind=SUPER,1,workspace,1
      bind=SUPER,2,workspace,2
      bind=SUPER,3,workspace,3
      bind=SUPER,4,workspace,4
      bind=SUPER,5,workspace,5
      bind=SUPER,6,workspace,6
      bind=SUPER,7,workspace,7
      bind=SUPER,8,workspace,8
      bind=SUPER,9,workspace,9
      bind=SUPER,0,workspace,0

      bind=ALT,1,movetoworkspace,1
      bind=ALT,2,movetoworkspace,2
      bind=ALT,3,movetoworkspace,3
      bind=ALT,4,movetoworkspace,4
      bind=ALT,5,movetoworkspace,5
      bind=ALT,6,movetoworkspace,6
      bind=ALT,7,movetoworkspace,7
      bind=ALT,8,movetoworkspace,8
      bind=ALT,9,movetoworkspace,9
      bind=ALT,0,movetoworkspace,0

      bind=SUPERSHIFT,left,movewindow,l
      bind=SUPERSHIFT,right,movewindow,r
      bind=SUPERSHIFT,up,movewindow,u
      bind=SUPERSHIFT,down,movewindow,d

      bind=SUPER,minus,splitratio,-0.25
      bind=SUPER,equal,splitratio,0.25

      bind=SUPER,T,exec,alacritty
      bind=SUPER,W,exec,qutebrowser

      bind=,XF86AudioRaiseVolume,exec,pamixer -i 5
      bind=,XF86AudioLowerVolume,exec,pamixer -d 5
      bind=,XF86AudioMute,exec,pamixer -t
      bind=,XF86AudioPlay,exec,playerctl play-pause

      exec-once=swaybg -i $NIXOS_CONFIG_DIR/modules/theming/wallpapers/cars/RX7/IMG_0086.JPG
      exec-once=himalaya notify &
      exec-once=element-desktop --hidden &
      exec-once=steam -silent &
    '';
  };
}
