{ ... }:

{
  programs.waybar = {
    enable = true;
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

        ipc = true;

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = [ 
            ""
            ""
            ""
            ""
          ];
        };

        "mpd" = {
          format = "{stateIcon} {album} - {title}";
          format-stopped = "";
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
            good = 95;
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
    '';
  };
}
