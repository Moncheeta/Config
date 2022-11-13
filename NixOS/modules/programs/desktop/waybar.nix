{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        height = 25;
        spacing = 10;

        modules-left = [
          "custom/dtname"
        ];
        modules-right = [
          "tray"
          "custom/sep"
          "pulseaudio"
          # "custom/minicava"
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
            format = " ";
            # format = "";
            tooltip = false;
        };

        "custom/minicava" = {
          format = "{}";
          max-length = 10;
          exec = "$CONFIG_DIR/Custom/Programs/minicava.sh";
        };

        "tray" = {
          icon-size = 12;
          spacing = 10;
          show-passive-items = true;
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
            default = [" " " "];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        "cpu" = {
          format = " {usage}%";
          interval = 1;
        };

        "memory" = {
          format = " {used:0.1f}/{total:0.1f}";
          interval = 1;
          tooltip = false;
        };

        "disk" = {
          path = "/";
          format = " {used}/{total}";
        };

        "network" = {
            format-wifi = "{essid}  ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
            format-disconnected = "Disconnected ⚠";
            tooltip = false;
            interval = 5;
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
          format = "{:%H:%M:%S}";
          timezone = "America/Chicago";
          interval = 1;
        };
      };
    };
    style = ../../../../Custom/Desktop/waybar.css;
  };
}