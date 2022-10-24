{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 200;
        height = 100;
        offset = "20x20";
        corner_radius = 10;
        follow = "mouse";
        font = "JetBrainsMono Nerd Font 10";
        foreground = "#e2e2e3";
        background = "#2c2e34";
        frame_width = 2;
        sort = "yes";
        markup = "full";
        separator_color = "frame";
        separator_height = 2;
        word_wrap = true;
      };
      urgency_low = {
        frame_color = "#9ed072";
        timeout = 3;
      };
      urgency_normal = {
        frame_color = "#76cce0";
        timeout = 5;
      };
      urgency_critical = {
        frame_color = "#fc5d7c";
        timeout = 0;
      };
    };
  };
}
