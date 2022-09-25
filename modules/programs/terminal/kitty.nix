{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 10;
    };
    settings = {
      cursor_shape = "block";

      scrollback_lines = 10000;

      enable_audio_bell = "no";

      hide_window_decorations = "yes";

      # Sonokai
      background = "#2c2e34";
      foreground = "#e2e2e3";

      cursor = "#e2e2e3";
      cursor_text_color = "background";

      # Black
      color0 = "#181819";
      color8 = "#7f8490";

      # Red
      color1 = "#fc5d7c";
      color9 = "#fc5d7c";

      # Green
      color2 = "#9ed072";
      color10 = "#9ed072";

      # Yellow
      color3 = "#e7c664";
      color11 = "#e7c664";

      # Blue
      color4 = "#76cce0";
      color12 = "#76cce0";

      # Magenta
      color5 = "#b39df3";
      color13 = "#b39df3";

      # Cyan
      color6 = "#f39660";
      color14 = "#f39660";

      # White
      color7 = "#e2e2e3";
      color15 = "#e2e2e3";

#     Molokai
#     background = "#191919";
#     foreground = "#c4c4b5";
#
#     cursor = "#f6f6ec";
#     selection_foreground = "#191919";
#     selection_background = "#343434";
#
#     # Black
#     color0 = "#191919";
#     # light black
#     color8 = "#615e4b";
#
#     # Red
#     color1 = "#f3005f";
#     # light red
#     color9 = "#f3005f";
#
#     # Green
#     color2 = "#97e023";
#     # light green
#     color10 = "#97e023";
#
#     # Yellow
#     color3 = "#fa8419";
#     # light yellow
#     color11 = "#dfd561";
#
#     # Blue
#     color4 = "#9c64fe";
#     # light blue
#     color12 = "#9c64fe";
#
#     # Magenta
#     color5 = "#f3005f";
#     # light magenta
#     color13 = "#f3005f";
#
#     # Cyan
#     color6 = "#57d1ea";
#     # light cyan
#     color14 = "#57d1ea";
#
#     # dull white
#     color7 = "#c4c4b5";
#     # bright white
#     color15 = "#f6f6ee";
    };
  };
}
