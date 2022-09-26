{ pkgs, ... }:

let 
  patched_waybar = pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  });
in {
  programs.waybar = {
    enable = true;
    package = patched_waybar;
    systemd = {
      enable = false;
      target = "hyprland-session.target";
    };
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        height = 12;
        spacing = 8;

        modules-left = [ 
          "custom/dtname"
          "custom/sep" 
          "wlr/workspaces" 
          "custom/spotify"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ 
          "tray"
          "custom/sep"
          "pulseaudio" 
          "custom/sep"
          "cpu" 
          "custom/sep" 
          "memory" 
          "custom/sep" 
          "disk" 
          "custom/sep" 
          "network" 
          "custom/sep" 
          "battery" 
          "clock" 
        ];

        "custom/sep" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };

        "custom/dtname" = {
            #format = " ";
            format = " ";
            tooltip = false;
        };

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
          };
        };

        "custom/spotify" = {
            format = "|  {}";
            max-length = 40;
            interval = 0;
            exec = "$NIXOS_CONFIG_DIR/modules/scripts/mediaplayer.sh";
            exec-if = "pgrep spotify";
        };

        "tray" = {
          icon-size = 12;
          spacing = 10;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = " {icon} {volume}%";
          format-muted = " ";
          format-icons = {
            headphone = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [" " " "];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        "cpu" = {
          format = " {usage}%";
        };

        "memory" = {
          format = " {used:0.1f}/{total:0.1f}GB";
        };

        "disk" = {
          path = "/";
          format = " {used} used of {total}";
        };

        "network" = {
            format-wifi = "{essid}  ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
            format-disconnected = "Disconnected ⚠";
            interval = ;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}% |";
          format-icons = [" " " " " " " " " "];
        };

        "clock" = {
          format = "{:%H:%M}";
          timezone = "America/Chicago";
        };
      };
    };
    style = ''
      * {
        color: #e2e2e3;
        background: #2c2e34;
        border: none;
        font-family: JetBrainsMono Nerd Font;
        font-weight: bold;
      }

      #custom-dtname {
        /*color: #76cce0;*/
        color: #b39df3;
      }

      #workspace button.active {
        background: #7f8490;
      }

      #custom-spotify {
        color: #9ed072;
      }

      #tray {
        color: #e7c664;
      }

      #pulseaudio {
        color: #76cce0;
      }

      #cpu {
        color: #b39df3;
      }

      #memory {
        color: #9ed072;
      }

      #disk {
        color: #f39660;
      }

      #network {
        color: #76cce0;
      }

      #battery {
        color: #9ed072;
      }

      #battery.warning:not(.charging) {
        color: #e7c664;
      }

      @keyframes blink {
        to {
          background-color: #2c2e34;
          color: #e2e2e3;
        }
      }

      #battery.critical:not(.charging) {
        color: #fc5d7c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };
}
