{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "200x30-20+20";
        corner_radius = 10;
        format = "<b>%s</b>\\n%b";
        follow = "mouse";
        font = "JetBrainsMono Nerd Font 10";
        foreground = "#e2e2e3";
        frame_width = 5;
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
