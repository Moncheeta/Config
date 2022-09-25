{ pkgs, ... }:

let
  patched_waybar = pkgs.waybar.overrideAttrs (oldAttrs: {
    patches = [
      ./waybar_patch
    ];
    #mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  });
in {
  programs.waybar = {
    enable = true;
    package = patched_waybar;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        height = 20;
        spacing = 8;

        modules-left = [ "wlr/workspaces" "mpd" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "tray" "pulseaudio" "cpu" "memory" "disk" "network" "battery" "clock" ];

        ipc = false;

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = [ 
            ""
            ""
            ""
            ""
          ];
        };

        "mpd" = {
          format = "{stateIcon} {album} - {title}";
          format-stopped = "Stopped ";
          format-disconnected = "";
          state-icons = { 
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
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
            format-wifi = "{essid} ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-disconnected = "Disconnected ⚠";
            interval = 7;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "clock" = {
          format = "{:%H:%M}";
          timezone = "America/Chicago";
        };
      };
    };
    style = ''
      * {
        
      }

      tooltip {

      }

      tooltip label {

      }

      #workspaces {
        
      }

      #workspaces button.focused {

      }

      #mpd {

      }

      window#waybar {

      }
      
      #tray {

      }

      #pulseaudio {

      }

      #pulseaudio.bluetooth {

      }

      #cpu {

      }

      #memory {

      }

      #disk {

      }

      #network {

      }

      #battery {

      }

      #battery.warning:not(.charging) {

      }

      #battery.critical:not(.charging) {

      }

      #clock {

      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }
    '';
  };
}
