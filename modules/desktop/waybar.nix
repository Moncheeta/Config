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
        height = 30;
        spacing = 3;

        modules-left = [ "wlr/workspaces" "mpd" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "cpu" "memory" "disk" "clock" ];

        ipc = true;

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = [ 
            " "
            " "
            " "
            " "
          ];
        };

        "mpd" = {
          format = "{stateIcon} {album} - {title}";
          format-stopped = "";
          state-icons = [
            " " " "
          ];
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        "pulseaudio" = {
          format = "{icon}{volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = [
            "" "" "" "" "" ["" ""]
          ];
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        "cpu" = {
          format = " {load}";
        };

        "memory" = {
          format = " {used}/{total}";
        };

        "disk" = {
          path = "/";
          format = " {used} used of {total}";
        };

        "clock" = {
          format = " {:%A, :%B :%d}  {:%H:%M}";
        };
      };
    };
  };
}
